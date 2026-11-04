# CKAD Lightning Labs - Answers & Explanations

> Questions adapted from **Lightning Lab 1** and **Lightning Lab 2** of the free [KodeKloud CKAD course notes](https://github.com/kodekloudhub/certified-kubernetes-application-developer-course) (credited to KodeKloud), adapted to this simulator's k3d environment: output files live under `/tmp/exam/` and node names follow the `k3d-cluster-*` convention.

## Question 1: PV, PVC and pod logger

### Solution

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: log-volume
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  storageClassName: manual
  hostPath:
    path: /opt/volume/nginx
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: log-claim
  namespace: default
spec:
  accessModes:
  - ReadWriteMany
  storageClassName: manual
  resources:
    requests:
      storage: 200Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: logger
  namespace: default
spec:
  volumes:
  - name: log-volume
    persistentVolumeClaim:
      claimName: log-claim
  containers:
  - name: logger
    image: nginx:alpine
    volumeMounts:
    - name: log-volume
      mountPath: /var/www/nginx
EOF
```

### Explanation

The PV must use `hostPath` (not a real provisioner) with `storageClassName: manual` so the PVC's matching class binds to it - a PVC with the default class would stay `Pending`. The PVC requests `200Mi` (less than the PV's `1Gi`, which is fine - the PV is allocated whole). The pod mounts the **claim**, not the PV directly. Verification checks the PVC is `Bound` to `log-volume` and the pod's Ready condition.

## Question 2: NetworkPolicy allow-webapp-color

### Solution

```bash
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-webapp-color
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: secure-pod
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: webapp-color
    ports:
    - port: 80
      protocol: TCP
EOF
```

### Explanation

The existing `default-deny-all` policy blocks everything, so this new policy is the only thing *allowing* traffic in. `podSelector` (no namespace selector) restricts the source to pods in the **same** namespace. Omitting `protocol` is fine (TCP is the default), but if you set it, it must be `TCP`. Do **not** delete or modify `default-deny-all`, `secure-pod`, `secure-service` or `webapp-color` - verification checks they all still exist.

## Question 3: Pod time-check with ConfigMap env

### Solution

```bash
kubectl create namespace dvl1987
kubectl create configmap time-config -n dvl1987 --from-literal=TIME_FREQ=10

kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: time-check
  namespace: dvl1987
spec:
  volumes:
  - name: log-volume
    emptyDir: {}
  containers:
  - name: time-check
    image: busybox
    command: ["/bin/sh", "-c"]
    args:
    - while true; do date >> /opt/time/time-check.log; sleep $TIME_FREQ; done
    env:
    - name: TIME_FREQ
      valueFrom:
        configMapKeyRef:
          name: time-config
          key: TIME_FREQ
    volumeMounts:
    - name: log-volume
      mountPath: /opt/time
EOF
```

### Explanation

The env var must use `valueFrom.configMapKeyRef` - a hardcoded `value: "10"` fails verification even though the pod would behave the same. The command must run in a shell (`/bin/sh -c`) so `$TIME_FREQ` expands, append with `>>` (not `>`), and `sleep $TIME_FREQ` with the **dollar sign** - the validator greps for the literal `sleep $TIME_FREQ`.

## Question 4: Deployment nginx-deploy, upgrade and rollback

### Solution

```bash
kubectl create deployment nginx-deploy --image=nginx:1.16 --replicas=4 \
  --overrides='{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxSurge":1,"maxUnavailable":2}}}}'

kubectl set image deployment/nginx-deploy nginx-deploy=nginx:1.17
kubectl rollout status deployment/nginx-deploy   # wait for the update

kubectl rollout undo deployment/nginx-deploy
```

### Explanation

Order matters: the strategy can be set at creation (or via `kubectl edit`), the image update must **complete** before the rollback so the rollout history records revision 2 (verification requires ≥2 revisions as evidence of the update), and `rollout undo` returns the image to `nginx:1.16`. After undo, all 4 pods must be available on `nginx:1.16` again.

## Question 5: Deployment redis with resources and volumes

### Solution

```bash
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      volumes:
      - name: data
        emptyDir: {}
      - name: config
        configMap:
          name: redis-config
      containers:
      - name: redis
        image: redis:alpine
        ports:
        - containerPort: 6379
        resources:
          requests:
            cpu: 200m
        volumeMounts:
        - name: data
          mountPath: /redis-master-data
        - name: config
          mountPath: /redis-master
EOF
```

### Explanation

The ConfigMap `redis-config` is pre-created by setup - only the volume referencing it is yours to define. Exactly **2** volumes are allowed (a stray third volume fails verification). CPU may be written as `200m` or `0.2`. The pod label `app=redis` must be on the **pod template**, not just the Deployment metadata.

## Question 6: Fix nginx1401 readiness and add liveness probe

### Solution

```bash
kubectl get pods -n dev1401                    # find the not-Ready pod: nginx1401
kubectl get pod nginx1401 -n dev1401 -o yaml > /tmp/exam/pod.yaml
```

Edit the manifest: the container serves on port `80` but the readiness probe points at `9080` - change `readinessProbe.httpGet.port` to `80`, and add:

```yaml
    livenessProbe:
      exec:
        command:
        - ls
        - /var/www/html/file_check
      initialDelaySeconds: 10
      periodSeconds: 60
```

Then recreate:

```bash
kubectl delete pod nginx1401 -n dev1401
kubectl apply -f /tmp/exam/pod.yaml
```

### Explanation

Pods can't be patched with a changed probe in place in practice - delete and recreate is expected (the question explicitly allows it). The readiness port fix makes the pod go `Ready`; the liveness probe uses `exec` (not `httpGet`) with the exact command `ls /var/www/html/file_check`, `initialDelaySeconds: 10`, `periodSeconds: 60`. Ignore the probe warnings - the file likely doesn't exist, but the verification only checks the **specification** plus the Ready condition from the fixed readiness probe.

## Question 7: CronJob dice

### Solution

```bash
kubectl apply -f - <<'EOF'
apiVersion: batch/v1
kind: CronJob
metadata:
  name: dice
  namespace: default
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      completions: 1
      backoffLimit: 25
      template:
        spec:
          containers:
          - name: dice
            image: kodekloud/throw-dice
          restartPolicy: Never
EOF
```

### Explanation

`completions: 1` and `backoffLimit: 25` live on the **Job** spec (`jobTemplate.spec`), not on the CronJob itself - putting them at CronJob level silently does nothing (and fails verification). `*/1 * * * *` is every minute.

## Question 8: Pod my-busybox with read-only secret volume

### Solution

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: my-busybox
  namespace: dev2406
spec:
  nodeSelector:
    kubernetes.io/hostname: k3d-cluster-server-0
  volumes:
  - name: secret-volume
    secret:
      secretName: dotfile-secret
  containers:
  - name: secret
    image: busybox
    command: ["/bin/sh", "-c", "sleep 3600"]
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/secret-volume
      readOnly: true
EOF
```

### Explanation

Three easy-to-miss details: the **container** must be named `secret` (not the pod), `readOnly: true` goes on the **volumeMount**, and in this k3d cluster the control-plane node is `k3d-cluster-server-0` (the KodeKloud lab says `controlplane`). Verification checks both the `nodeSelector` and that the pod actually landed on that node.

## Question 9: Ingress ingress-vh-routing

### Solution

```bash
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-vh-routing
  namespace: default
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: watch.ecom-store.com
    http:
      paths:
      - path: /video
        pathType: Prefix
        backend:
          service:
            name: video-service
            port:
              number: 8080
  - host: apparels.ecom-store.com
    http:
      paths:
      - path: /wear
        pathType: Prefix
        backend:
          service:
            name: apparels-service
            port:
              number: 8080
EOF
```

### Explanation

Each hostname gets its own rule with its own path and backend. The annotation key is `nginx.ingress.kubernetes.io/rewrite-target` with value exactly `/`. Both services (`video-service`, `apparels-service`) are pre-created by setup on port 8080.

## Question 10: Redirect WARNING log lines to a file

### Solution

```bash
kubectl logs dev-pod-dind-878516 -n default | grep WARNING > /tmp/exam/dind-878516_logs.txt
```

### Explanation

`kubectl logs` streams the container's output; `grep WARNING` keeps only the lines containing `WARNING`, and `>` writes them to the file under `/tmp/exam/` (the KodeKloud lab uses the home directory - here it's `/tmp/exam/`). Use `>` (create/overwrite), not `>>`. Verification checks the file is non-empty, every line contains `WARNING`, and the line count doesn't exceed the WARNING lines actually present in the logs.
