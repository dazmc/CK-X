# CKA Practice Lab - Troubleshooting & Cluster Maintenance

Solutions for all 16 questions, ordered simple to hard.

## Question 1: List Worker Nodes

### Solution

```bash
kubectl get nodes
kubectl get nodes --no-headers | awk '$1 !~ /server-0/ {print $1}' > /tmp/exam/nodes.txt
```

### Explanation

`kubectl get nodes` shows every node including the control-plane (`k3d-cluster-server-0`). We filter out the server node so only the worker agents (`k3d-cluster-agent-0`, `k3d-cluster-agent-1`, ...) end up in the file. You can also use `kubectl get nodes -l node-role.kubernetes.io/agent` or JSONPath:

```bash
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep -v server-0 > /tmp/exam/nodes.txt
```

## Question 2: Labeled Pods and kubectl Output

### Solution

```bash
for i in 1 2 3; do
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: web-$i
  namespace: pod-basics
  labels:
    app: web
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
EOF
done

kubectl wait --for=condition=Ready pod -l app=web -n pod-basics --timeout=120s

kubectl get pods -n pod-basics -l app=web --field-selector=status.phase=Running \
  --no-headers | awk '{print $1}' > /tmp/exam/running-pods.txt
```

### Explanation

The label `app=web` lets you select all three pods with `-l app=web`. Writing the running pod names to the file demonstrates simple `kubectl` output processing.

## Question 3: Node Label and nodeSelector

### Solution

```bash
kubectl label node k3d-cluster-agent-1 disk=ssd

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespace: node-select
spec:
  nodeSelector:
    disk: ssd
  containers:
  - name: nginx
    image: nginx:1.27
EOF
```

### Explanation

`nodeSelector` is the simplest form of scheduling: the pod only lands on nodes carrying the exact label key/value pair. Always label the node **before** creating the pod, otherwise it stays `Pending`.

## Question 4: Deployment with NodePort Service

### Solution

```bash
kubectl create deployment web-app --image=nginx:1.27 --replicas=2 -n nodeport-lab
kubectl label deployment web-app app=web-app -n nodeport-lab --overwrite

# Easiest with an overlay:
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: nodeport-lab
spec:
  type: NodePort
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30088
EOF
```

### Explanation

A `NodePort` service opens a fixed port (30000–32767) on **every** node. `kubectl expose` can do this too (`kubectl expose deploy web-app --name=web-svc --type=NodePort --node-port=30088 -n nodeport-lab`), but the manual manifest makes the port mapping explicit.

## Question 5: Fix ImagePullBackOff

### Solution

```bash
kubectl set image deployment/web-recovery nginx=nginx:1.27 -n image-fix
kubectl rollout status deployment/web-recovery -n image-fix
```

### Explanation

The image `nginx:1.25.12-typo` does not exist, so the kubelet cannot pull it. `kubectl set image` performs a rolling update to the correct image. The exam often includes one "broken deployment" - check events with `kubectl describe pod` and confirm the fix with `kubectl get pods`.

## Question 6: Batch Job with Completions and TTL

### Solution

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: batch-worker
  namespace: batch-jobs
spec:
  completions: 4
  parallelism: 2
  backoffLimit: 6
  ttlSecondsAfterFinished: 120
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: worker
        image: busybox:1.36
        command: ["sh", "-c", "echo processing && sleep 5"]
EOF
```

### Explanation

- `completions: 4` - the job is done when 4 pods succeed
- `parallelism: 2` - up to 2 pods run at once
- `backoffLimit: 6` - at most 6 failed retries before the job is marked Failed
- `ttlSecondsAfterFinished: 120` - the job object is garbage-collected 2 minutes after completion
- `restartPolicy` must be `Never` (or `OnFailure`) for jobs

## Question 7: Approve a CSR

### Solution

```bash
kubectl get csr
kubectl certificate approve app-web-csr
```

### Explanation

Pending `CertificateSigningRequest` objects must be approved before the controller issues a certificate. The command sets the `Approved` condition. Use `kubectl certificate deny <name>` for the opposite - here denying fails the task.

## Question 8: Expand a PVC

### Solution

The claim `data-pvc` is already mounted by the pod `data-pod` (that's what keeps it `Bound` with `WaitForFirstConsumer`), so you only need to enable expansion and resize:

```bash
kubectl patch storageclass expandable -p '{"allowVolumeExpansion": true}'

kubectl patch pvc data-pvc -n storage-expand \
  -p '{"spec":{"resources":{"requests":{"storage":"5Gi"}}}}'
```

### Explanation

Volume expansion only works when the `StorageClass` sets `allowVolumeExpansion: true` — patch the PVC first without it and the API server rejects the request. Once allowed, you simply patch the PVC's requested size upward (the order matters: StorageClass first, then PVC). Shrinking is **not** supported. The PVC stays `Bound` and `data-pod` keeps running while the volume is resized online.

## Question 9: Service With No Endpoints

### Solution

```bash
kubectl get svc frontend-svc -n svc-endpoints -o yaml
# -> selector is app: webapp but the pods are labeled app: frontend

kubectl patch svc frontend-svc -n svc-endpoints -p '{"spec":{"selector":{"app":"frontend"}}}'

kubectl get endpoints frontend-svc -n svc-endpoints
```

### Explanation

A service finds its backends through its `selector`. If the selector doesn't match any pod labels, the Endpoints object stays empty and the service routes nowhere. The classic symptom: `curl` to the service times out while the pods are perfectly healthy.

## Question 10: NetworkPolicy Debugging

### Solution

The policy selects `from: podSelector: app=frontend`, but the pods that should have access are labeled `access=granted`:

```bash
kubectl edit netpol backend-access -n netpol-debug
```

Change the ingress `from` block to:

```yaml
  ingress:
  - from:
    - podSelector:
        matchLabels:
          access: granted
    ports:
    - port: 80
```

Test it:

```bash
kubectl exec tester -n netpol-debug -- wget -q -O /dev/null http://backend.netpol-debug.svc.cluster.local/
```

### Explanation

NetworkPolicies select peers by label. A typo or wrong label silently blocks all traffic because a policy with an ingress rule becomes **default-deny** for everything it doesn't explicitly allow. `kubectl describe netpol` is the fastest way to inspect the rules.

## Question 11: kubectl debug on a Pod That Never Becomes Ready

### Solution

Investigate with an ephemeral container:

```bash
kubectl debug app-crasher -n debug-pod -it --image=busybox:1.36 --target=app -- sh
# inside:
ps                                  # see the app's waiting loop (shared process namespace)
ls -la /app/config/                 # note: the ephemeral container has its own rootfs,
                                    # so the pod's emptyDir mount is not visible here
```

The pod logs tell the story:

```bash
kubectl logs app-crasher -n debug-pod
# ERROR: missing /app/config/settings.conf - waiting for config
```

The app container is alive and waiting, so you can create the missing file directly in it (the ephemeral container does **not** inherit the app container's volume mounts, so `kubectl exec` on the app container is the reliable fix):

```bash
kubectl exec app-crasher -n debug-pod -- \
  sh -c 'echo "mode=production" > /app/config/settings.conf'

kubectl get pod app-crasher -n debug-pod   # 1/1 Ready
```

### Explanation

`kubectl debug -it --image=busybox --target=<container>` attaches an ephemeral container sharing the target's **process** namespace - this only works while the target container is running, which is why the exercise pod waits in a loop instead of crashlooping. The ephemeral container is for *investigation*; volume mounts belong to each container, so the fix is applied in the app container itself. Once `settings.conf` exists, the readiness probe (`test -f /app/config/settings.conf`) passes and the pod flips to `Ready`.

## Question 12: Deprecated API Versions

### Solution

Update each file in `/tmp/exam/deprecations/` and apply:

**deployment.yaml** - `apps/v1beta2` → `apps/v1` (same structure):

```bash
sed -i 's|apps/v1beta2|apps/v1|' /tmp/exam/deprecations/deployment.yaml
kubectl apply -f /tmp/exam/deprecations/deployment.yaml
```

**ingress.yaml** - `extensions/v1beta1` → `networking.k8s.io/v1` (new fields required):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: legacy-ingress
  namespace: api-update
spec:
  rules:
  - host: legacy.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: legacy-svc
            port:
              number: 80
```

**cronjob.yaml** - `batch/v1beta1` → `batch/v1` (extra nesting level):

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: legacy-cron
  namespace: api-update
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:                # <- Job spec level (added)
      template:
        spec:            # <- Pod spec level
          containers:
          - name: hello
            image: busybox:1.36
            command: ["echo", "hello"]
          restartPolicy: OnFailure
```

```bash
kubectl apply -f /tmp/exam/deprecations/ingress.yaml
kubectl apply -f /tmp/exam/deprecations/cronjob.yaml
```

### Explanation

Removed APIs return `the server could not find the requested resource`. The three classic CKA conversions are `apps/v1beta2` → `apps/v1`, `extensions/v1beta1` Ingress → `networking.k8s.io/v1` (adds `pathType` and the nested `backend.service` block), and `batch/v1beta1` CronJob → `batch/v1` (adds the `jobTemplate.spec` layer). `kubectl apply` errors tell you exactly which version to use; `kubectl convert` or the deprecated-API migration guide are your references in the real exam.

## Question 13: RBAC 403 Troubleshooting

### Solution

Confirm the failure the same way the application calls the API:

```bash
kubectl auth can-i list pods -n rbac-debug --as=system:serviceaccount:rbac-debug:pod-viewer   # yes
kubectl auth can-i get configmaps -n rbac-debug --as=system:serviceaccount:rbac-debug:pod-viewer  # no
```

Add the missing permission to the existing role:

```bash
kubectl edit role pod-inspector -n rbac-debug
```

```yaml
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get"]
```

Verify:

```bash
kubectl auth can-i get configmaps -n rbac-debug --as=system:serviceaccount:rbac-debug:pod-viewer  # yes
kubectl auth can-i get configmaps -n kube-system --as=system:serviceaccount:rbac-debug:pod-viewer # no
```

### Explanation

`kubectl auth can-i --as=system:serviceaccount:<ns>:<name>` impersonates a service account and is the fastest way to reproduce a 403. Extend the **Role** (namespaced) rather than creating a ClusterRole - the task explicitly fails if the fix leaks permissions outside the namespace.

## Question 14: Topology Spread Constraints

### Solution

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spread-app
  namespace: spread
spec:
  replicas: 4
  selector:
    matchLabels:
      app: spread-app
  template:
    metadata:
      labels:
        app: spread-app
    spec:
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: kubernetes.io/hostname
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
          matchLabels:
            app: spread-app
      containers:
      - name: nginx
        image: nginx:1.27
EOF
```

### Explanation

`topologySpreadConstraints` is the modern replacement for most anti-affinity use cases. `maxSkew: 1` with `DoNotSchedule` guarantees the replica count difference between any two nodes never exceeds 1, so 4 replicas split 2/2 across the two worker nodes. Don't forget the `labelSelector` inside the constraint - without it the constraint doesn't apply to your pods.

## Question 15: Multi-Fault Troubleshooting

### Solution

**Fault 1 - readiness probe:** the probe checks `/readyz`, which nginx doesn't serve.

```bash
kubectl edit deployment shop -n repair
# change readinessProbe.httpGet.path from /readyz to /
```

**Fault 2 - service selector:** the service selects `app: shop-frontend` but pods are labeled `app: shop`.

```bash
kubectl patch svc shop-svc -n repair -p '{"spec":{"selector":{"app":"shop"}}}'
```

**Fault 3 - targetPort:** the service targets `8080` while nginx listens on `80`.

```bash
kubectl patch svc shop-svc -n repair -p '{"spec":{"ports":[{"port":80,"targetPort":80}]}}'
```

Verify:

```bash
kubectl get pods -n repair -l app=shop                    # 3/3 Ready
kubectl get endpoints shop-svc -n repair                  # 3 addresses
```

### Explanation

This mirrors real incident triage: separate symptoms (pods not Ready, service not routing) can have independent root causes. Work layer by layer - pod health first (probes), then service discovery (selector), then port mapping (targetPort). `kubectl describe svc` and `kubectl describe pod` surface all three quickly.

## Question 16: Node Maintenance Recovery

### Solution

```bash
kubectl uncordon k3d-cluster-agent-1
kubectl taint nodes k3d-cluster-agent-1 dedicated=critical:NoSchedule-

kubectl rollout restart deployment/critical-app -n maintenance
kubectl rollout status deployment/critical-app -n maintenance
```

### Explanation

Cordoned nodes have `spec.unschedulable: true`, so the scheduler won't place pods there - the deployment's pods stayed `Pending`. `kubectl uncordon` re-enables scheduling. The `dedicated=critical:NoSchedule` taint would still block pods without a matching toleration, so remove it with the `-` suffix. A `rollout restart` (or any template change) triggers rescheduling of the stuck replicas onto the restored node.
