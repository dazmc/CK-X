# CKA Mock Exams 2 & 3 - Answers & Explanations

> Questions adapted from **Mock Exam 2** and **Mock Exam 3** of the free [KodeKloud CKA course notes](https://github.com/kodekloudhub/certified-kubernetes-administrator-course) (credited to KodeKloud), adapted to this simulator's k3d environment: output files live under `/tmp/exam/`, node names follow the `k3d-cluster-*` convention, and the etcd backup / node SSH tasks are replaced with equivalents that work here.

## Question 1: Pod redis-storage with an emptyDir volume

### Solution

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: redis-storage
  namespace: default
spec:
  volumes:
  - name: redis-storage
    emptyDir: {}
  containers:
  - name: redis-storage
    image: redis:alpine
    volumeMounts:
    - name: redis-storage
      mountPath: /data/redis
```

```bash
kubectl apply -f redis-storage.yaml
```

### Explanation

`emptyDir` is created fresh with the pod and lives only as long as it - ideal for scratch space. The volume **name** must match the `volumeMounts.name`, and the verification checks both the `emptyDir` type and the `/data/redis` mount path.

## Question 2: Pod super-user-pod with SYS_TIME

### Solution

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: super-user-pod
  namespace: default
spec:
  containers:
  - name: super-user-pod
    image: busybox:1.28
    command: ["sleep", "4800"]
    securityContext:
      capabilities:
        add: ["SYS_TIME"]
```

### Explanation

Capabilities are dropped by default; `securityContext.capabilities.add` grants extra ones. `SYS_TIME` lets the container change the system clock. Note `add` is a list - `add: ["SYS_TIME"]` (or the YAML block form) both work.

## Question 3: PVC my-pvc and pod use-pv

### Solution

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
  namespace: default
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: use-pv
  namespace: default
spec:
  volumes:
  - name: mypod
    persistentVolumeClaim:
      claimName: my-pvc
  containers:
  - name: use-pv
    image: nginx
    volumeMounts:
    - name: mypod
      mountPath: /data
```

```bash
kubectl apply -f pvc-pod.yaml
```

### Explanation

The default storage class dynamically provisions a backing volume, so the PVC reaches `Bound` without a pre-created PV. The pod references the claim by `claimName` - the volume name itself (`mypod` here) is free-form but must match between `volumes` and `volumeMounts`.

## Question 4: Rolling update of nginx-deploy

### Solution

```bash
kubectl create deployment nginx-deploy --image=nginx:1.16 --replicas=1
kubectl set image deployment/nginx-deploy nginx=nginx:1.17
kubectl rollout history deployment nginx-deploy
```

### Explanation

`kubectl set image` triggers a rolling update and records a new revision, so `rollout history` shows revisions 1 and 2. Verification checks three things: the deployment spec now says `nginx:1.17`, history has ≥2 revisions, and all running pods actually use `1.17` (if the update is still in progress, the pod check fails until it completes).

## Question 5: DNS troubleshooting with nslookup

### Solution

```bash
kubectl run nginx-resolver --image=nginx
kubectl expose pod nginx-resolver --name=nginx-resolver-service --port=80 --target-port=80

# Service lookup
kubectl run test-nslookup --image=busybox:1.28 --rm -it --restart=Never \
  -- nslookup nginx-resolver-service > /tmp/exam/nginx.svc

# Pod IP lookup - get the IP first
kubectl get pod nginx-resolver -o wide
kubectl run test-nslookup --image=busybox:1.28 --rm -it --restart=Never \
  -- nslookup <POD-IP>.default.pod > /tmp/exam/nginx.pod
```

### Explanation

Two different DNS records are being proven: the **service** name (`nginx-resolver-service.default.svc`) resolves to the ClusterIP, and the **pod** IP in `<ip-with-dashes>.default.pod` form resolves back to the pod. The verification greps each file for the actual ClusterIP / pod IP, so stale or swapped files fail. Remember `mkdir -p /tmp/exam` first if the directory doesn't exist.

## Question 6: RBAC for the pvviewer ServiceAccount

### Solution

```bash
kubectl create serviceaccount pvviewer
kubectl create clusterrole pvviewer-role --resource=persistentvolumes --verb=list
kubectl create clusterrolebinding pvviewer-role-binding \
  --clusterrole=pvviewer-role --serviceaccount=default:pvviewer
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pvviewer
  namespace: default
spec:
  serviceAccountName: pvviewer
  containers:
  - name: pvviewer
    image: redis
```

```bash
kubectl apply -f pvviewer-pod.yaml
```

### Explanation

RBAC grants are additive: the ClusterRole allows `list` on `persistentvolumes`, the ClusterRoleBinding ties it to the `default/pvviewer` ServiceAccount, and the pod must opt in via `serviceAccountName` (the default ServiceAccount gets nothing). Test with `kubectl auth can-i list persistentvolumes --as=system:serviceaccount:default:pvviewer`.

## Question 7: Export node InternalIPs

### Solution

```bash
mkdir -p /tmp/exam
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' \
  > /tmp/exam/node_ips
```

### Explanation

The JSONPath filter `?(@.type=="InternalIP")` selects only internal addresses (ExternalIP is `<none>` here). Output is space-separated on one line - exactly what the verification compares against the live node IPs.

## Question 8: multi-pod with two containers

### Solution

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-pod
  namespace: default
spec:
  containers:
  - name: alpha
    image: nginx
    env:
    - name: name
      value: alpha
  - name: beta
    image: busybox
    command: ["sleep", "4800"]
    env:
    - name: name
      value: beta
```

```bash
kubectl apply -f multi-pod.yaml
```

### Explanation

Containers in one pod share the network namespace and volumes but have their own images, commands and env vars. Both must be Running for the pod to be `Running` - note `nginx` never sleeps, so the pod stays up as long as `beta` sleeps.

## Question 9: Pod non-root-pod

### Solution

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: non-root-pod
  namespace: default
spec:
  securityContext:
    runAsUser: 1000
    fsGroup: 2000
  containers:
  - name: non-root-pod
    image: redis:alpine
```

```bash
kubectl apply -f non-root-pod.yaml
```

### Explanation

The question specifies the **pod-level** security context (applies to all containers). `runAsUser: 1000` runs processes as UID 1000; `fsGroup: 2000` makes mounted volumes group-owned by GID 2000. Setting these on the container instead would fail the verification - the check reads `spec.securityContext`.

## Question 10: NetworkPolicy ingress-to-nptest

### Solution

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-to-nptest
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: np-test-1
  policyTypes:
  - Ingress
  ingress:
  - ports:
    - protocol: TCP
      port: 80
```

```bash
kubectl apply -f ingress-to-nptest.yaml
```

### Explanation

`podSelector` chooses which pods the policy applies to; once any policy selects a pod, all ingress not explicitly allowed is denied. `policyTypes: [Ingress]` declares that ingress is enforced (it's implied when an `ingress` rule exists, but declaring it is best practice). Omitting `protocol` is fine - TCP is the default.

## Question 11: Taint, toleration and nodeSelector

### Solution

```bash
kubectl taint node k3d-cluster-agent-1 env_type=production:NoSchedule
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: prod-redis
  namespace: default
spec:
  nodeSelector:
    kubernetes.io/hostname: k3d-cluster-agent-1
  tolerations:
  - key: env_type
    operator: Equal
    value: production
    effect: NoSchedule
  containers:
  - name: prod-redis
    image: redis:alpine
```

```bash
kubectl run dev-redis --image=redis:alpine
kubectl apply -f prod-redis.yaml
```

### Explanation

The taint repels pods that don't tolerate it, so `dev-redis` must land on a different node. A **toleration alone doesn't attract** a pod to the tainted node - it only permits it - which is why the task also asks for a `nodeSelector` pinning `prod-redis` to `k3d-cluster-agent-1`. Verify with `kubectl get pods -o wide`.

## Question 12: Fix super.kubeconfig

### Solution

```bash
# See what's wrong
kubectl --kubeconfig=/tmp/exam/super.kubeconfig get nodes
# error: connect to host ... port 2379: connection refused

# Compare with the working config
grep server: /home/candidate/.kube/kubeconfig
grep server: /tmp/exam/super.kubeconfig
```

Fix the port (2379 is etcd, not the API server):

```bash
sed -i 's/:2379/:6443/' /tmp/exam/super.kubeconfig
```

```bash
kubectl --kubeconfig=/tmp/exam/super.kubeconfig get nodes
```

### Explanation

Port 2379 is the **etcd** client port - a classic mix-up. The kubeconfig's `server:` URL must point at the API server on 6443. Any edit that removes the 2379 reference and leaves a working 6443 server URL passes; the final proof is `kubectl get nodes` succeeding with that kubeconfig.
