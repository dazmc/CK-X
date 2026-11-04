# CKS Mock Exam Practice - Answers & Explanations

> Questions adapted from **Mock Exams 1-3** of the free [KodeKloud CKS course notes](https://github.com/kodekloudhub/certified-kubernetes-security-specialist-cks-course) (credited to KodeKloud), adapted to this simulator's k3d environment: only tasks achievable with kubectl-only access from the jumphost are included (host-bound tasks such as kube-bench, Falco, Trivy, Kubesec and API-server manifest edits are omitted), output files live under `/tmp/exam/`.

## Question 1: Extract secret and remount app-xyz

### Solution

```bash
kubectl get secret a-safe-secret -n orion -o jsonpath='{.data.CONNECTOR_PASSWORD}' | base64 -d \
  > /tmp/exam/secrets/CONNECTOR_PASSWORD
```

Write a **fresh manifest** rather than dumping the live pod - `kubectl get pod -o yaml` includes the auto-injected `kube-api-access-*` token volume, and re-applying a dump either keeps the token mounted or creates duplicate `volumes:`/`volumeMounts:` YAML keys (last one wins, silently dropping your edit):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-xyz
  namespace: orion
  labels:
    name: app-xyz
spec:
  volumes:
  - name: secret-volume
    secret:
      secretName: a-safe-secret
  containers:
  - name: app-xyz
    image: nginx
    volumeMounts:
    - name: secret-volume
      mountPath: /mnt/connector/password
      readOnly: true
```

Then recreate:

```bash
kubectl delete pod app-xyz -n orion
kubectl apply -f /tmp/exam/app-xyz.yaml
```

### Explanation

The decoded value must be written **before** deleting the pod (or read from the Secret object, which survives pod deletion - either way). The env var must be *removed*, not just supplemented: verification fails if `CONNECTOR_PASSWORD` is still in `env`. `readOnly: true` on the volumeMount is required, and the mount path is exactly `/mnt/connector/password` - mounting the secret directory (`/mnt/connector`) instead would fail.

## Question 2: NetworkPolicy allow-redis-access

### Solution

```bash
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-redis-access
  namespace: prod-x12cs
spec:
  podSelector:
    matchLabels:
      run: redis-backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          backend: prod-x12cs
    ports:
    - port: 6379
      protocol: TCP
  - from:
    - namespaceSelector:
        matchLabels:
          access: redis
    ports:
    - port: 6379
      protocol: TCP
EOF
```

### Explanation

Two separate `from` entries (one rule each) - putting both selectors in a **single** `from` entry would require the source to satisfy *both* simultaneously (AND, not OR), blocking the intended traffic. The namespace selector uses the **existing** label `access=redis` on namespace `prod-yx13cs` (set up by setup script). The first rule's bare `podSelector` means "pods in the same namespace" with `backend=prod-x12cs`. Everything else stays blocked because the policy declares `Ingress` with only these allowances.

## Question 3: Unmount the SA token from apps-cluster-dash

### Solution

Write a **fresh manifest** (a `kubectl get pod -o yaml` dump already contains the auto-injected `kube-api-access-*` token volume and mount - re-applying it keeps the token mounted no matter what you set):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: apps-cluster-dash
  namespace: gamma
  labels:
    run: apps-cluster-dash
spec:
  automountServiceAccountToken: false
  serviceAccountName: cluster-view
  containers:
  - name: apps-cluster-dash
    image: nginx
```

```bash
kubectl delete pod apps-cluster-dash -n gamma
kubectl apply -f /tmp/exam/pod.yaml
```

If you insist on editing the dump instead, you must delete **both** the `volumes:` entry and the container `volumeMounts:` entry for `kube-api-access-*` in addition to adding the flag - duplicate YAML keys (two `volumes:` blocks) silently drop one copy.

### Explanation

`automountServiceAccountToken: false` on the **pod** stops the token volume from being injected. Keep `serviceAccountName: cluster-view`. Verification checks the flag, that no token volume/mount remains at `/var/run/secrets/kubernetes.io/serviceaccount`, and that the pod is Ready.

## Question 4: Tighten Role dev-user-access in dev-z

### Solution

```bash
kubectl edit role dev-user-access -n dev-z
```

Change the rule to:

```yaml
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

Or imperatively:

```bash
kubectl create role dev-user-access -n dev-z --resource=pods --verb=get,list \
  --dry-run=client -o yaml | kubectl replace -f -
```

### Explanation

Only `get` and `list` on pods - **no** `watch`, `create`, `delete`, etc. (verification rejects any extra verb). Keep the same role name and don't touch `dev-a`/`dev-b` (they must keep `*` for martin) or the RoleBindings. Check your work with:

```bash
kubectl auth can-i create pods -n dev-z --as=martin   # no
kubectl auth can-i list pods -n dev-z --as=martin     # yes
kubectl auth can-i delete pods -n dev-a --as=martin   # yes
```

## Question 5: RBAC for the developer ServiceAccount

### Solution

```bash
kubectl create namespace dev

kubectl apply -f - <<'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: dev-write
  namespace: dev
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list", "create"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: developer
  namespace: dev
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev-write-binding
  namespace: dev
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: dev-write
subjects:
- kind: ServiceAccount
  name: developer
  namespace: dev
EOF
```

Update the pod template at `/tmp/exam/dev-pod.yaml` to add under `spec`:

```yaml
  serviceAccountName: developer
```

Then:

```bash
kubectl apply -f /tmp/exam/dev-pod.yaml
```

### Explanation

Exactly four verbs: `get, watch, list, create` - adding `delete` or `update` fails verification. The RoleBinding's `roleRef` must point at Role `dev-write` and the subject must be kind `ServiceAccount` named `developer`. The pod must run with `serviceAccountName: developer` - the template ships with the default SA, so you must edit it first. Verify with `kubectl auth can-i create pods -n dev --as=system:serviceaccount:dev:developer` → `yes`.

## Question 6: Delete non-immutable pods in alpha

### Solution

```bash
kubectl delete pod sonata -n alpha
kubectl delete pod triton -n alpha
```

### Explanation

`immutable` means `readOnlyRootFilesystem: true` in the container's securityContext:

- `solaris` - sets `readOnlyRootFilesystem: true` → **keep**
- `sonata` - sets `readOnlyRootFilesystem: false` → **delete**
- `triton` - field absent → defaults to **false** (mutable) → **delete**

The trap is `triton`: an absent field is *not* "maybe immutable" - Kubernetes defaults it to `false`.

## Question 7: Least-privilege service account for frontend-site

### Solution

```bash
kubectl get rolebinding -n omni       # inspect: fe and frontend have bindings; frontend-default has none
```

Recreate the pod under the least-privilege SA:

```bash
kubectl delete pod frontend-site -n omni
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: frontend-site
  namespace: omni
  labels:
    run: nginx
spec:
  serviceAccountName: frontend-default
  containers:
  - name: nginx
    image: nginx:alpine
EOF
```

Then delete the unused service accounts:

```bash
kubectl delete serviceaccount fe -n omni
kubectl delete serviceaccount frontend -n omni
```

### Explanation

Inspecting the RoleBindings shows `fe` (get/list/create/delete pods) and `frontend` (get/list/update configmaps) have permissions, while `frontend-default` is bound to nothing - that's the minimum-privilege SA (excluding `default`). Keep `frontend-default` and `default`; delete `fe` and `frontend` **after** the pod no longer uses them (deleting the SA while the pod still runs would break the pod). The pod must end up `Ready`.

## Question 8: RuntimeClass gvisor for busy-rx100

### Solution

```bash
kubectl get pod busy-rx100 -n production -o yaml > /tmp/exam/pod.yaml
```

Add under `spec`:

```yaml
  runtimeClassName: gvisor
```

Then recreate:

```bash
kubectl delete pod busy-rx100 -n production
kubectl apply -f /tmp/exam/pod.yaml
```

### Explanation

The `RuntimeClass` object `gvisor` already exists (created by setup) - you only set `runtimeClassName: gvisor` on the pod. Since the gvisor handler isn't actually installed in this cluster, the pod may stay pending or fail to start - that's expected; verification is **spec-only** (runtimeClassName set, pod still exists with image `nginx` and label `run=busy-rx100`). Don't wait for it to go Ready.
