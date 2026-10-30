#!/bin/bash
# Setup for Question 15: Multi-fault troubleshooting
# Deployment has 3 deliberate faults:
#  1) readinessProbe hits a wrong path -> pods never become Ready
#  2) service selector does not match pod labels -> no Endpoints
#  3) service targetPort points to 8080 while the container listens on 80
kubectl create namespace repair --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'EOF2'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: shop
  namespace: repair
spec:
  replicas: 3
  selector:
    matchLabels:
      app: shop
  template:
    metadata:
      labels:
        app: shop
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /readyz
            port: 80
          initialDelaySeconds: 2
          periodSeconds: 5
EOF2

kubectl apply -f - <<'EOF2'
apiVersion: v1
kind: Service
metadata:
  name: shop-svc
  namespace: repair
spec:
  selector:
    app: shop-frontend
  ports:
  - port: 80
    targetPort: 8080
EOF2
exit 0
