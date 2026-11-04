#!/bin/bash
DEP=nginx-deploy
if ! kubectl get deployment $DEP -n default >/dev/null 2>&1; then
  echo "Deployment $DEP not found"; exit 1
fi
REPS=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.replicas}')
IMG=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.template.spec.containers[0].image}')
[ "$REPS" = "1" ] || { echo "Replicas is '$REPS', expected 1"; exit 1; }
[ "$IMG" = "nginx:1.17" ] || { echo "Image is '$IMG', expected nginx:1.17"; exit 1; }
echo "Deployment has 1 replica with image nginx:1.17"; exit 0
