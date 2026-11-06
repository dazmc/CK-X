#!/bin/bash
D=storefront-canary
if ! kubectl get deployment $D -n ckad-canary >/dev/null 2>&1; then
  echo "Deployment $D not found in ckad-canary"; exit 1
fi
R=$(kubectl get deployment $D -n ckad-canary -o jsonpath='{.spec.replicas}')
IMG=$(kubectl get deployment $D -n ckad-canary -o jsonpath='{.spec.template.spec.containers[0].image}')
[ "$R" = "2" ] || { echo "canary replicas is '${R:-none}', expected 2"; exit 1; }
[ "$IMG" = "nginx:1.25-alpine" ] || { echo "canary image is '${IMG:-none}', expected nginx:1.25-alpine"; exit 1; }
echo "Canary has 2 replicas of nginx:1.25-alpine"; exit 0
