#!/bin/bash
# Setup for Question 7: secure namespace with one nginx pod behind the policy
# (source: techiescamp Q19)
kubectl create namespace secure --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: web
  namespace: secure
  labels:
    app: web
spec:
  containers:
    - name: nginx
      image: nginx:1.27
      ports:
        - containerPort: 80
EOF
exit 0
