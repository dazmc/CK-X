#!/bin/bash
# Setup for Question 9: deployment that CrashLoopBackOffs until a ConfigMap is mounted
# (source: theplatformlab mock exam Q1)
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payments-api
  namespace: prod
spec:
  replicas: 1
  selector:
    matchLabels:
      app: payments-api
  template:
    metadata:
      labels:
        app: payments-api
    spec:
      containers:
        - name: app
          image: busybox:1.36
          command: ["sh", "-c", "test -f /etc/app/app.env && exec sleep 3600"]
EOF
exit 0
