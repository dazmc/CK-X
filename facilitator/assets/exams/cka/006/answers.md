# CKA Practice Lab - Answers & Explanations

> Questions adapted from the free, MIT-licensed [theplatformlab/CKA-Certified-Kubernetes-Administrator](https://github.com/theplatformlab/CKA-Certified-Kubernetes-Administrator) exercises and Mock Exam 01 (credited to theplatformlab), adapted to this simulator's kubectl-only k3d environment: node-level exercises (kubelet, kubeadm, etcd, audit logs, static-pod files) are excluded because there is no SSH to nodes, the Ingress question is validated at spec level since no ingress controller runs in this cluster, the resource-tuning task uses an explicit ResourceQuota as the constraint (k3d node capacity is not artificially capped), and the WaitForFirstConsumer task uses the dynamic `rancher.io/local-path` provisioner instead of a static local PV (whose directory cannot be created without node access).

## Question 1: RBAC with subresources

### Solution

```bash
kubectl create sa dev-sa -n rbac-ex04

cat <<'EOF' | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-manager
  namespace: rbac-ex04
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch", "create", "delete"]
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "list"]
- apiGroups: ["apps"]
  resources: ["deployments/scale"]
  verbs: ["patch"]
EOF

kubectl create rolebinding dev-pod-access -n rbac-ex04 \
  --role=pod-manager --serviceaccount=rbac-ex04:dev-sa

kubectl create clusterrole node-viewer --verb=get,list --resource=nodes
kubectl create clusterrolebinding dev-node-access \
  --clusterrole=node-viewer --serviceaccount=rbac-ex04:dev-sa
```

### Explanation

Three traps here, all straight from the source exercise:

1. **The `deployments/scale` subresource is not covered by `deployments`.** Wildcards do not
   include subresources either - you must grant `resources: ["deployments/scale"]` explicitly,
   in the `apps` API group (not `""`). `kubectl auth can-i patch deployments/scale` is the
   quickest way to confirm.
2. **Core resources use `apiGroups: [""]`**, not `"v1"`.
3. **RoleBinding is namespaced, ClusterRoleBinding is not.** The Role keeps permissions inside
   `rbac-ex04` (so `list pods` in `default` returns `no`), while the ClusterRoleBinding is what
   makes `list nodes` return `yes`.

```bash
kubectl auth can-i list pods -n rbac-ex04 --as=system:serviceaccount:rbac-ex04:dev-sa   # yes
kubectl auth can-i patch deployments/scale -n rbac-ex04 --as=system:serviceaccount:rbac-ex04:dev-sa  # yes
kubectl auth can-i delete deployments -n rbac-ex04 --as=system:serviceaccount:rbac-ex04:dev-sa       # no
kubectl auth can-i list nodes --as=system:serviceaccount:rbac-ex04:dev-sa                            # yes
```

## Question 2: Native sidecar logging

### Solution

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: logger
  namespace: sidecar-ex02
spec:
  replicas: 1
  selector:
    matchLabels:
      app: logger
  template:
    metadata:
      labels:
        app: logger
    spec:
      initContainers:
        - name: log-agent
          image: busybox:1.36
          restartPolicy: Always
          command: ["sh", "-c", "tail -F /var/log/app/app.log"]
          volumeMounts:
            - name: log-volume
              mountPath: /var/log/app
      containers:
        - name: app
          image: busybox:1.36
          command: ["sh", "-c", "while true; do echo \"$(date) - app running\" >> /var/log/app/app.log; sleep 3; done"]
          volumeMounts:
            - name: log-volume
              mountPath: /var/log/app
      volumes:
        - name: log-volume
          emptyDir: {}
EOF

kubectl rollout status deploy/logger -n sidecar-ex02
kubectl logs deploy/logger -n sidecar-ex02 -c log-agent   # streams "app running" lines
```

### Explanation

A **native sidecar** is an *init container* with `restartPolicy: Always`. Kubernetes starts it
before the main container and keeps it running alongside it (and stops it last). If you put
`log-agent` under `containers:` instead, it is just an ordinary second container with no
ordering guarantee - the question's whole point. Both containers must mount the same `emptyDir`
so they see the same file, and `tail -F` (capital F) is used so the sidecar waits for the file
to be created by the app container and survives log rotation.

## Question 3: Ingress with TLS

### Solution

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  namespace: ingress-ex19
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - api.example.com
      secretName: api-tls-cert
  rules:
    - host: web.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web-service
                port:
                  number: 80
    - host: api.example.com
      http:
        paths:
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: api-service
                port:
                  number: 8080
EOF
```

### Explanation

`spec.ingressClassName: nginx` selects the controller class (an annotation-based class is the
legacy form). The `tls` section terminates HTTPS for `api.example.com` using the pre-created
Secret - it is host-scoped, so `web.example.com` is intentionally not listed there. Each rule
is host-based, each path needs `pathType: Prefix` (it is a required field in
`networking.k8s.io/v1`), and the backend **port is the Service port** (`8080` for
`api-service`, not the container port `80`).

## Question 4: Resource tuning under a ResourceQuota

### Solution

Check what is happening first:

```bash
kubectl describe rs -n resource-tuning | grep -A2 FailedCreate
# FailedCreate: pods "web-..." is forbidden: exceeded quota: compute-quota,
#   requested: 1500m, used: 0, limit: 1000m
```

The three replicas ask for `3 x 500m = 1500m` CPU and `3 x 1Gi = 3Gi` memory, but the quota
allows `1000m` / `2Gi`. Lower the per-container requests so the totals fit, e.g. `200m` CPU
and `512Mi` memory:

```bash
kubectl patch deploy web -n resource-tuning --type=json -p='[
  {"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/cpu","value":"200m"},
  {"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/memory","value":"512Mi"}
]'
kubectl rollout status deploy/web -n resource-tuning
```

Totals then become `600m` CPU (`<= 1000m`) and `1.5Gi` memory (`<= 2Gi`) - all three pods are
admitted and schedule.

### Explanation

A ResourceQuota on `requests.cpu`/`requests.memory` rejects pod creation *at admission time*
when the sum of requests would exceed the limit - the ReplicaSet just emits `FailedCreate`
events and nothing runs. The fix is always to **reduce requests, not to delete them**: the
question requires requests to stay declared (a container with no requests counts as zero and
would game the check), and the quota itself must not be edited. `kubectl describe rs` (or
`kubectl get events`) shows the exact `requested / limit` numbers you need to calculate the
fix.

## Question 5: WaitForFirstConsumer storage

### Solution

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-wffc
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
EOF

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: local-pvc
  namespace: wffc-ex25
spec:
  accessModes: ["ReadWriteOnce"]
  storageClassName: local-wffc
  resources:
    requests:
      storage: 1Gi
EOF

kubectl get pvc local-pvc -n wffc-ex25     # Pending ... and that is expected

cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  namespace: wffc-ex25
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
        - name: app
          image: busybox:1.36
          command: ["sh", "-c", "sleep 3600"]
          volumeMounts:
            - name: data
              mountPath: /data
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: local-pvc
EOF

kubectl get pvc local-pvc -n wffc-ex25     # Bound
```

### Explanation

With `volumeBindingMode: WaitForFirstConsumer` the control plane deliberately leaves the claim
`Pending` until a Pod actually consumes it, because the volume must be provisioned **on the
node where the Pod lands** (local storage is node-affine). Creating the Pod triggers
provisioning + binding + scheduling in one step. If you expected `Bound` immediately and saw
`Pending`, check the StorageClass binding mode before assuming something is broken - that
"stuck" PVC is the intended behaviour. (The source exercise does this with a static local PV
and `kubernetes.io/no-provisioner`; here we use the dynamic `rancher.io/local-path`
provisioner because the static variant needs a pre-created directory on the node, and nodes
are not reachable from the jumphost.)

## Question 6: Node drain and cordon

### Solution

```bash
kubectl cordon k3d-cluster-agent-1
kubectl get nodes                              # agent-1 shows SchedulingDisabled

kubectl drain k3d-cluster-agent-1 --ignore-daemonsets --delete-emptydir-data

kubectl get pod drain-marker -n drain-ex08     # Error from server (NotFound) - evicted

kubectl uncordon k3d-cluster-agent-1

kubectl scale deploy/drain-demo -n drain-ex08 --replicas=4
kubectl rollout status deploy/drain-demo -n drain-ex08
kubectl get pods -n drain-ex08 -o wide         # pods on agent-1 again
```

### Explanation

`kubectl drain` refuses to proceed without `--ignore-daemonsets` (DaemonSet pods are
node-managed and must stay) and without `--delete-emptydir-data` (pods with local `emptyDir`
data would otherwise block eviction - the lab's `drain-marker` pod has one on purpose, so a
naive drain fails). Drain **evicts** (uses the eviction API, deletes) every other pod;
workload controllers immediately recreate their pods on the remaining schedulable nodes, which
is why the deployment survives. While the node is cordoned its `spec.unschedulable` is `true`,
so the new replicas only come back to `k3d-cluster-agent-1` after `kubectl uncordon`.
`kubectl uncordon` is just `kubectl cordon --node-selector=...`-style editing of the same
field - the scheduler uses it, taints are a separate mechanism.

## Question 7: Rollout, change-cause and rollback

### Solution

```bash
kubectl create deploy webapp -n rollout-ex06 --image=nginx:1.27 --replicas=3 \
  --dry-run=client -o yaml > webapp.yaml
# edit webapp.yaml: labels app=webapp, strategy:
#   type: RollingUpdate
#   rollingUpdate: {maxSurge: 1, maxUnavailable: 0}
kubectl apply -f webapp.yaml

kubectl annotate deployment webapp -n rollout-ex06 \
  kubernetes.io/change-cause="initial deploy nginx:1.27"

kubectl set image deployment/webapp nginx=nginx:1.28 -n rollout-ex06
kubectl annotate deployment webapp -n rollout-ex06 \
  kubernetes.io/change-cause="update to nginx:1.28" --overwrite

kubectl rollout status deployment/webapp -n rollout-ex06
kubectl rollout history deployment/webapp -n rollout-ex06   # 2 revisions

kubectl rollout undo deployment/webapp -n rollout-ex06
kubectl get deploy webapp -n rollout-ex06 \
  -o jsonpath='{.spec.template.spec.containers[0].image}'    # nginx:1.27
```

### Explanation

`--record` is gone (removed in recent releases) - the supported way to make
`kubectl rollout history` show a cause is the `kubernetes.io/change-cause` **annotation on the
Deployment object**. Because it lives on the object, not on a revision, the second `annotate`
needs `--overwrite` or it errors with "annotation already exists". After the update you have
two revisions (1.27 and 1.28); `rollout undo` restores the previous pod template but creates a
*new* revision rather than rewinding history, and it does not touch the change-cause
annotation. The intermediate `nginx:1.28` ReplicaSet stays around (scaled to 0), which is how
the grader proves the update really happened before the rollback.

## Question 8: CronJob with retry behaviour

### Solution

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: db-cleanup
  namespace: cron-ex21
spec:
  schedule: "*/5 * * * *"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      backoffLimit: 2
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: cleanup
              image: busybox:1.37
              command: ["sh", "-c", "echo cleanup; date"]
EOF

kubectl create job db-cleanup-manual --from=cronjob/db-cleanup -n cron-ex21
kubectl get job db-cleanup-manual -n cron-ex21 -w     # 1/1 Complete
```

### Explanation

`concurrencyPolicy: Forbid` means a run is skipped if the previous one is still active - the
default (`Allow`) would pile up overlapping cleanup jobs. `backoffLimit: 2` caps retries of a
*failing* pod (otherwise a broken job retries forever). `restartPolicy: Never` (with
`backoffLimit`) is what lets the Job controller count attempts instead of restarting the same
pod forever. Note `backoffLimit` belongs to `spec.jobTemplate.spec`, while
`concurrencyPolicy` belongs to the CronJob itself - a common misplacement. `kubectl create job
--from=cronjob/...` clones the jobTemplate immediately, which is also how you test a schedule
that will not fire during the exam.

## Question 9: Fix CrashLoopBackOff with a ConfigMap

### Solution

```bash
kubectl create configmap payments-config -n prod \
  --from-literal=app.env=$'DB_HOST=postgres.prod.svc.cluster.local'

kubectl patch deploy payments-api -n prod --type=json -p='[
  {"op":"add","path":"/spec/template/spec/volumes/-",
   "value":{"name":"app-config","configMap":{"name":"payments-config"}}},
  {"op":"add","path":"/spec/template/spec/containers/0/volumeMounts/-",
   "value":{"name":"app-config","mountPath":"/etc/app"}}
]'

kubectl rollout status deploy/payments-api -n prod
kubectl exec -n prod deploy/payments-api -- cat /etc/app/app.env
```

### Explanation

The container exits 1 because `/etc/app/app.env` does not exist; every restart repeats the
same failure, hence CrashLoopBackOff. The fix is to *provide the file*, not to change the
command: mount the ConfigMap as a volume at `/etc/app` - a ConfigMap volume materialises each
key as a file named after the key, so the key `app.env` becomes `/etc/app/app.env`. Patching
the template triggers a fresh rollout (new pods, no inherited backoff), and the pod starts on
the first attempt. Changing the command or writing the file with a `postStart` hook would also
stop the crashes but violates the "without changing the command" requirement.

## Question 10: Job with three completions

### Solution

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: cleanup-job
  namespace: job-ex21
spec:
  completions: 3
  parallelism: 1
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: cleanup
          image: busybox:1.37
          command: ["sh", "-c", "echo Cleanup complete"]
EOF

kubectl get job cleanup-job -n job-ex21 -w     # 3/3 Complete
```

### Explanation

`completions: 3` means "succeed three times in total", **not** "run three pods at once" - that
is `parallelism`. With `parallelism: 1` the three runs happen one after another (you will see
three pods, but only one at a time), giving `3/3` on the Job. `restartPolicy: Never` makes each
attempt a distinct pod so the controller can count completions. The Job's `status.succeeded`
reaches 3 and the Job turns `Complete`; completed Jobs keep their status even if their pods are
later cleaned up or evicted.
