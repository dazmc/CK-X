#!/bin/bash
# Setup for Question 9: Service with mismatched selector (no Endpoints)
kubectl create namespace svc-endpoints --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'EOF2'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: svc-endpoints
spec:
  replicas: 2
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
        image: nginx:1.27
        ports:
        - containerPort: 80
EOF2

# Service intentionally selects app=webapp while pods are labeled app=frontend
kubectl apply -f - <<'EOF2'
apiVersion: v1
kind: Service
metadata:
  name: frontend-svc
  namespace: svc-endpoints
spec:
  selector:
    app: webapp
  ports:
  - port: 80
    targetPort: 80
EOF2
exit 0
