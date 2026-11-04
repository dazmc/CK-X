#!/bin/bash
# Setup for Question 2: redis-backend pod/service + namespaces with existing labels
kubectl delete networkpolicy allow-redis-access -n prod-x12cs --ignore-not-found >/dev/null 2>&1
kubectl create namespace prod-x12cs --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace prod-yx13cs --dry-run=client -o yaml | kubectl apply -f -
kubectl label namespace prod-yx13cs access=redis --overwrite
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: redis-backend
  namespace: prod-x12cs
  labels:
    run: redis-backend
spec:
  containers:
  - name: redis-backend
    image: redis:alpine
    ports:
    - containerPort: 6379
---
apiVersion: v1
kind: Pod
metadata:
  name: backend-client
  namespace: prod-x12cs
  labels:
    backend: prod-x12cs
spec:
  containers:
  - name: backend-client
    image: busybox
    command: ["sleep", "3600"]
---
apiVersion: v1
kind: Pod
metadata:
  name: yx13cs-app
  namespace: prod-yx13cs
  labels:
    app: yx13cs-app
spec:
  containers:
  - name: yx13cs-app
    image: busybox
    command: ["sleep", "3600"]
---
apiVersion: v1
kind: Service
metadata:
  name: redis-backend
  namespace: prod-x12cs
spec:
  selector:
    run: redis-backend
  ports:
  - port: 6379
    targetPort: 6379
EOF
exit 0
