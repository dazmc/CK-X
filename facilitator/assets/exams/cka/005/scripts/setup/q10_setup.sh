#!/bin/bash
# Setup for Question 10: pre-create the target pod
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: np-test-1
  namespace: default
  labels:
    run: np-test-1
spec:
  containers:
  - name: nginx
    image: nginx
EOF
exit 0
