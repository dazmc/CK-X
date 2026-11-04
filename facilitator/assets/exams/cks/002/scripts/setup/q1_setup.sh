#!/bin/bash
# Setup for Question 1: pod using the secret as an env var
mkdir -p /tmp/exam/secrets
kubectl create namespace orion --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic a-safe-secret -n orion \
  --from-literal=CONNECTOR_PASSWORD='Sup3rS3cret!Pass' \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl delete pod app-xyz -n orion --ignore-not-found --wait=true >/dev/null 2>&1
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: app-xyz
  namespace: orion
  labels:
    name: app-xyz
spec:
  containers:
  - name: app-xyz
    image: nginx
    env:
    - name: CONNECTOR_PASSWORD
      valueFrom:
        secretKeyRef:
          name: a-safe-secret
          key: CONNECTOR_PASSWORD
EOF
exit 0
