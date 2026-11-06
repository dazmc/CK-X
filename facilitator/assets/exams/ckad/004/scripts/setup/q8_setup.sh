#!/bin/bash
# Setup for Question 8: toolbox deployment without security context (from spudale lab 10)
kubectl create namespace ckad-security --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: toolbox
  namespace: ckad-security
spec:
  replicas: 1
  selector:
    matchLabels:
      app: toolbox
  template:
    metadata:
      labels:
        app: toolbox
    spec:
      containers:
        - name: toolbox
          image: busybox:1.36
          command: ["sh", "-c", "while true; do sleep 3600; done"]
EOF
exit 0
