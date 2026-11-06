# CKAD Practice Labs - Answers & Explanations

> Questions adapted from the free [spudale/ckad-exam-preparation](https://github.com/spudale/ckad-exam-preparation) labs (credited to spudale), adapted to this simulator's k3d environment: file-based tasks live under `/tmp/exam/`, and the Ingress troubleshooting lab (source lab 08) is validated at the Service/Ingress spec level since no ingress controller runs in this cluster.

## Question 1: Move hard-coded values to a Secret

### Solution

```bash
kubectl -n ckad-secret create secret generic postgres-credentials \
  --from-literal=database=inventory --from-literal=password=ckad-password
```

Edit the Deployment (`kubectl -n ckad-secret edit deployment postgres-client`) and replace the two `env` entries:

```yaml
          env:
            - name: POSTGRES_DB
              valueFrom:
                secretKeyRef:
                  name: postgres-credentials
                  key: database
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: postgres-credentials
                  key: password
```

Wait for the automatic rollout: `kubectl -n ckad-secret rollout status deployment/postgres-client`.

### Explanation

The Secret keys (`database`, `password`) differ from the env var names (`POSTGRES_DB`, `POSTGRES_PASSWORD`), so `kubectl set env --from=secret/...` won't work - it uses the Secret key names as the variable names. Each entry must use `valueFrom.secretKeyRef` with both `name` and `key`; any leftover literal `value` fails verification. The Deployment rollout creates a fresh Pod, which is what "redeploy" means here - you can't mutate a running Pod's env.

## Question 2: Configure, perform and roll back an update

### Solution

```bash
kubectl -n ckad-rollout patch deployment frontend --type=strategic -p \
  '{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxUnavailable":1,"maxSurge":2}}}}'

kubectl -n ckad-rollout set image deployment/frontend nginx=nginx:1.25-alpine
kubectl -n ckad-rollout rollout status deployment/frontend

kubectl -n ckad-rollout rollout undo deployment/frontend
kubectl -n ckad-rollout rollout status deployment/frontend
```

### Explanation

Order matters: the strategy can be set any time, but the image update must **complete** before the rollback so the rollout history records revision 2 (verification requires ≥2 revisions as evidence you actually did the update). `rollout undo` returns to the previous revision - `nginx:1.24-alpine` - with all 4 replicas available. Setting the strategy after the update would still pass the strategy check but the history check would catch a skipped update.

## Question 3: Pod CPU limit from a LimitRange

### Solution

Inspect the constraint first:

```bash
kubectl -n ckad-pod-cpu get limitrange cpu-constraints -o yaml
# max.cpu = "1"  ->  half is 500m
```

Edit `/tmp/exam/pod.yaml` - add the limit under the existing `resources`, leaving the request untouched:

```yaml
      resources:
        requests:
          cpu: 200m
        limits:
          cpu: 500m
```

Then:

```bash
kubectl create -f /tmp/exam/pod.yaml
kubectl -n ckad-pod-cpu wait --for=condition=Ready pod/worker --timeout=90s
```

### Explanation

The point of the exercise is reading the LimitRange rather than assuming `500m` - the validator hard-codes the expected result, but in the real exam the maximum could differ. The existing `requests.cpu: 200m` must be preserved (verification checks it), and only `limits.cpu` is added. Note `kubectl create`, not `apply` - the manifest starts as the "provided file" state.

## Question 4: Replace a deprecated API version

### Solution

Edit `/tmp/exam/deprecated-deployment.yaml`:

1. Change `apiVersion: extensions/v1beta1` → `apiVersion: apps/v1`
2. Add the required selector (mandatory since `apps/v1`):

```yaml
spec:
  replicas: 2
  selector:
    matchLabels:
      app: legacy-web
  template:
    ...
```

Then:

```bash
kubectl apply -f /tmp/exam/deprecated-deployment.yaml
kubectl -n ckad-api rollout status deployment/legacy-web
```

### Explanation

`extensions/v1beta1` was removed in Kubernetes 1.16 - applying it fails outright, which is the starting condition. `apps/v1` requires `spec.selector` (it was optional/inferred in the old API), and the selector must match the Pod-template labels or the Deployment is rejected. The namespace in the manifest must be `ckad-api` (the question's target) - fix it if your copy differs.

## Question 5: Rename a container and update its image

### Solution

Strategic merge patch identifies containers by name, so patching name+image together can leave you with two containers. Use a JSON patch:

```bash
kubectl -n ckad-container patch deployment api --type=json -p='[
  {"op":"replace","path":"/spec/template/spec/containers/0/name","value":"web-container"},
  {"op":"replace","path":"/spec/template/spec/containers/0/image","value":"nginx:1.25-alpine"}
]'
kubectl -n ckad-container rollout status deployment/api
```

Or edit the Deployment directly and change both fields in place.

### Explanation

This is the classic CKAD container-update trap: a strategic merge patch with `name: web-container` doesn't match the existing `old-container`, so Kubernetes *adds* a second container instead of renaming. The JSON patch (`--type=json`) replaces the fields by array index. Verification requires **exactly one** container named `web-container` with image `nginx:1.25-alpine`, plus a completed rollout.

## Question 6: Create a CronJob with history limits

### Solution

```bash
kubectl apply -f - <<'EOF'
apiVersion: batch/v1
kind: CronJob
metadata:
  name: half-hour-report
  namespace: ckad-cron
spec:
  schedule: "*/30 * * * *"
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  jobTemplate:
    spec:
      activeDeadlineSeconds: 3
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: sp
              image: busybox:1.28
              command:
                - /bin/sh
                - -c
                - date; echo Hello from the Kubernetes cluster
EOF

kubectl -n ckad-cron create job --from=cronjob/half-hour-report manual-test
```

### Explanation

Placement of the fields is what's being tested: `activeDeadlineSeconds` belongs on the **Job** spec (`spec.jobTemplate.spec`), while `successfulJobsHistoryLimit`/`failedJobsHistoryLimit` sit on the **CronJob** spec. `restartPolicy: Never` is required for Jobs (Jobs don't allow `Always`). `--from=cronjob/...` copies the Job template to create `manual-test` immediately - note the inherited 3-second deadline means this Job may fail with `DeadlineExceeded`; the verification only checks that it exists.

## Question 7: Canary deployment (80/20 split)

### Solution

Scale the stable deployment and add a distinguishing label to its **Pod template**:

```bash
kubectl -n ckad-canary scale deployment/storefront --replicas=8
kubectl -n ckad-canary patch deployment/storefront --type=strategic -p \
  '{"spec":{"template":{"metadata":{"labels":{"track":"stable"}}}}}'
```

Create the canary:

```bash
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: storefront-canary
  namespace: ckad-canary
spec:
  replicas: 2
  selector:
    matchLabels:
      app: storefront
      track: canary
  template:
    metadata:
      labels:
        app: storefront
        track: canary
    spec:
      containers:
        - name: storefront
          image: nginx:1.25-alpine
          ports:
            - containerPort: 80
EOF
```

Wait for both: `kubectl -n ckad-canary rollout status deployment/storefront deployment/storefront-canary`.

### Explanation

The Service selector stays `app: storefront` so it routes to **both** versions - 8 stable + 2 canary endpoints = the approximate 80/20 split (verification counts 10 ready EndpointSlice entries). The stable Deployment's `spec.selector` **cannot be changed** - it is immutable on modern Kubernetes (patching it fails with `spec.selector: field is immutable`), so the distinguishing label goes on its **Pod template** only, where the existing `app: storefront` selector still matches. The *canary* Deployment is new, so its selector can (and must) include `track: canary` - two Deployments with identical selectors would fight over the same Pods (the second `apply` is rejected as an overlapping-selector error). Total Pods: 8 + 2 = 10, exactly the namespace cap.

## Question 8: Security context and capabilities

### Solution

```bash
kubectl -n ckad-security patch deployment toolbox --type=strategic -p '{
  "spec":{"template":{"spec":{"containers":[{
    "name":"toolbox",
    "securityContext":{
      "runAsUser":1000,
      "capabilities":{"add":["NET_ADMIN","SYS_TIME"]}
    }
  }]}}}}'
kubectl -n ckad-security rollout status deployment/toolbox
```

### Explanation

`runAsUser` must be at the **container** level (verification reads `containers[0].securityContext.runAsUser` - a pod-level `securityContext.runAsUser` would fail). Capabilities go under `securityContext.capabilities.add`. This cluster admits the added capabilities, so the rollout completes; on clusters with a restricted Pod Security admission the manifest would still be the correct answer but might be rejected - inspect the error rather than bypassing policy.

## Question 9: Diagnose and fix a ServiceAccount/RBAC issue

### Solution

```bash
kubectl -n ckad-rbac logs deployment/inspector
# -> ... cannot list resource "pods" ... for system:serviceaccount:ckad-rbac:default

kubectl auth can-i list pods -n ckad-rbac --as=system:serviceaccount:ckad-rbac:default     # no
kubectl auth can-i list pods -n ckad-rbac --as=system:serviceaccount:ckad-rbac:log-reader   # no
kubectl auth can-i list pods -n ckad-rbac --as=system:serviceaccount:ckad-rbac:pod-reader   # yes
```

`log-reader` only grants `pods/log` (reading logs, not listing Pods); `read-pods` (get/list) is bound to `pod-reader`. Fix only the Deployment:

```bash
kubectl -n ckad-rbac patch deployment inspector --patch-file solution.yaml
# or: kubectl -n ckad-rbac edit deployment inspector  ->  serviceAccountName: pod-reader
kubectl -n ckad-rbac rollout status deployment/inspector
```

### Explanation

A running Pod does **not** mean its API requests are authorized - the container loops through the error, so the Pod stays healthy while every `kubectl get pods` returns `Forbidden`. The comparison (`kubectl auth can-i ... --as=...`) is the fast way to find the right ServiceAccount. Verification checks three things: the Deployment now uses `pod-reader`, the Roles/RoleBindings are byte-for-byte unchanged (you may not "fix" it by granting `default` more permissions), and the new Pod's logs list Pods with no `Forbidden`.

## Question 10: Fix the inaccessible stack

### Solution

Layer by layer:

```bash
kubectl -n ckad-ingress-fix get endpointslice -l kubernetes.io/service-name=catalog   # empty!
kubectl -n ckad-ingress-fix get pods --show-labels                                    # app=catalog
kubectl -n ckad-ingress-fix get service catalog -o yaml                               # selector: app=catalogue (typo)
```

**Bug 1** - the Service selector says `app: catalogue` but the Pods are labeled `app: catalog`:

```bash
kubectl -n ckad-ingress-fix patch service catalog -p '{"spec":{"selector":{"app":"catalog"}}}'
```

**Bug 2** - the Ingress routes to backend service `catalogtest`, which doesn't exist:

```bash
kubectl -n ckad-ingress-fix patch ingress catalog --type=json -p \
  '[{"op":"replace","path":"/spec/rules/0/http/paths/0/backend/service/name","value":"catalog"}]'
```

Endpoints appear within seconds once the selector matches.

### Explanation

Always walk the chain: Ingress → Service → Endpoints → Pod. The empty EndpointSlice immediately implicates the Service selector (a `describe ingress` also shows "no endpoints" for the backend). The one-letter selector typo (`catalogue` vs `catalog`) is the source lab's intended bug; the `catalogtest` backend name is a second defect the verification also requires you to catch. You may only touch what's wrong - the Deployment, its labels and the Service's ports stay as they are. (In this simulator there's no ingress controller, so correctness is verified on the Ingress/Service spec and live endpoints rather than an HTTP round-trip.)
