#!/bin/bash
# Setup for Question 6: pod with readiness probe on the wrong port
kubectl create namespace dev1401 --dry-run=client -o yaml | kubectl apply -f -
kubectl delete pod nginx1401 -n dev1401 --ignore-not-found --wait=true >/dev/null 2>&1
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: nginx1401
  namespace: dev1401
  labels:
    run: nginx1401
spec:
  containers:
  - name: nginx1401
    image: nginx:alpine
    ports:
    - containerPort: 80
    readinessProbe:
      httpGet:
        path: /
        port: 9080
      initialDelaySeconds: 1
      periodSeconds: 5
EOF
exit 0
