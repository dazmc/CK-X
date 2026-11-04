#!/bin/bash
# Setup for Question 6: three pods with different readOnlyRootFilesystem settings
kubectl create namespace alpha --dry-run=client -o yaml | kubectl apply -f -
for P in solaris sonata triton; do kubectl delete pod $P -n alpha --ignore-not-found --wait=true >/dev/null 2>&1; done
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: solaris
  namespace: alpha
  labels:
    run: solaris
spec:
  containers:
  - name: solaris
    image: nginx
    securityContext:
      readOnlyRootFilesystem: true
---
apiVersion: v1
kind: Pod
metadata:
  name: sonata
  namespace: alpha
  labels:
    run: sonata
spec:
  containers:
  - name: sonata
    image: nginx
    securityContext:
      readOnlyRootFilesystem: false
---
apiVersion: v1
kind: Pod
metadata:
  name: triton
  namespace: alpha
  labels:
    run: triton
spec:
  containers:
  - name: triton
    image: nginx
EOF
exit 0
