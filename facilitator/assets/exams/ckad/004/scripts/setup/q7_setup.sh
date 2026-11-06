#!/bin/bash
# Setup for Question 7: storefront deployment + service at 5 replicas (from spudale lab 09)
kubectl create namespace ckad-canary --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: storefront
  namespace: ckad-canary
spec:
  replicas: 5
  selector:
    matchLabels:
      app: storefront
  template:
    metadata:
      labels:
        app: storefront
    spec:
      containers:
        - name: storefront
          image: nginx:1.24-alpine
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: storefront
  namespace: ckad-canary
spec:
  selector:
    app: storefront
  ports:
    - port: 80
      targetPort: 80
EOF
exit 0
