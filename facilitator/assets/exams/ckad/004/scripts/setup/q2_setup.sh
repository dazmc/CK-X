#!/bin/bash
# Setup for Question 2: frontend deployment at nginx:1.24-alpine (from spudale lab 02)
kubectl create namespace ckad-rollout --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: ckad-rollout
spec:
  replicas: 4
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: nginx
          image: nginx:1.24-alpine
EOF
exit 0
