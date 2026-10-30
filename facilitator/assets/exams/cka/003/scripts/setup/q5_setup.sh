#!/bin/bash
# Setup for Question 5: Deployment stuck in ImagePullBackOff
kubectl create namespace image-fix --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'EOF2'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-recovery
  namespace: image-fix
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-recovery
  template:
    metadata:
      labels:
        app: web-recovery
    spec:
      containers:
      - name: nginx
        # Wrong image tag on purpose - causes ImagePullBackOff
        image: nginx:1.25.12-typo
        ports:
        - containerPort: 80
EOF2
exit 0
