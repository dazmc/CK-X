#!/bin/bash
# Setup for Question 9: create the broken pod with the command typo
kubectl delete pod orange -n default --ignore-not-found --wait=true >/dev/null 2>&1
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: orange
  namespace: default
spec:
  containers:
  - name: orange
    image: busybox:1.36
    command: ["sleeeep", "3000"]
EOF
exit 0
