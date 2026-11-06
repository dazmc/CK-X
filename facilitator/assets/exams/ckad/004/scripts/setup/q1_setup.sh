#!/bin/bash
# Setup for Question 1: deployment with hard-coded env values (from spudale lab 01)
kubectl create namespace ckad-secret --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-client
  namespace: ckad-secret
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres-client
  template:
    metadata:
      labels:
        app: postgres-client
    spec:
      containers:
        - name: client
          image: busybox:1.36
          command: ["sh", "-c", "while true; do sleep 3600; done"]
          env:
            - name: POSTGRES_DB
              value: inventory
            - name: POSTGRES_PASSWORD
              value: ckad-password
EOF
exit 0
