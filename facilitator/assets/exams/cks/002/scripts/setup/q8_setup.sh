#!/bin/bash
# Setup for Question 8: RuntimeClass gvisor + pod without it
kubectl create namespace production --dry-run=client -o yaml | kubectl apply -f -
cat <<'EOF' | kubectl apply -f -
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: gvisor
handler: gvisor
EOF
kubectl delete pod busy-rx100 -n production --ignore-not-found --wait=true >/dev/null 2>&1
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: busy-rx100
  namespace: production
  labels:
    run: busy-rx100
spec:
  containers:
  - name: busy-rx100
    image: nginx
EOF
exit 0
