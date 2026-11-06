#!/bin/bash
# Setup for Question 5: deployment with old container name/image (from spudale lab 05)
kubectl create namespace ckad-container --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: ckad-container
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: old-container
          image: nginx:1.24-alpine
EOF
exit 0
