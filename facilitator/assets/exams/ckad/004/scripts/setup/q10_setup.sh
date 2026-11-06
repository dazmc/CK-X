#!/bin/bash
# Setup for Question 10: catalog stack with two bugs - svc selector + ingress backend (from spudale lab 08)
kubectl create namespace ckad-ingress-fix --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: catalog
  namespace: ckad-ingress-fix
spec:
  replicas: 1
  selector:
    matchLabels:
      app: catalog
  template:
    metadata:
      labels:
        app: catalog
    spec:
      containers:
        - name: nginx
          image: nginx:1.25-alpine
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: catalog
  namespace: ckad-ingress-fix
spec:
  selector:
    app: catalogue
  ports:
    - port: 80
      targetPort: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: catalog
  namespace: ckad-ingress-fix
spec:
  ingressClassName: nginx
  rules:
    - host: catalog.ckad.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: catalogtest
                port:
                  number: 80
EOF
exit 0
