#!/bin/bash
# Setup for Question 4: namespace + deprecated manifest that cannot be applied (from spudale lab 04)
kubectl create namespace ckad-api --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /tmp/exam
cat > /tmp/exam/deprecated-deployment.yaml <<'EOF'
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: legacy-web
  namespace: ckad-api
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: legacy-web
    spec:
      containers:
        - name: nginx
          image: nginx:1.25-alpine
EOF
exit 0
