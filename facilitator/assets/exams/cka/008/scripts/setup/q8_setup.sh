#!/bin/bash
# Setup for Question 8: pod with an unpullable image (candidate fixes the reference)
# (source: techiescamp Q25)
kubectl create namespace image-pull --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: bad-image
  namespace: image-pull
spec:
  containers:
    - name: bad-image
      image: nginx:1.27-typo
EOF
exit 0
