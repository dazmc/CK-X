#!/bin/bash
# Setup for Question 4: ResourceQuota + deployment whose requests exceed it
# (source: theplatformlab exercise 23 + mock exam Q10)
kubectl create namespace resource-tuning --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: resource-tuning
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 2Gi
    pods: "10"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: resource-tuning
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx:1.27
          resources:
            requests:
              cpu: 1200m
              memory: 1Gi
EOF
exit 0
