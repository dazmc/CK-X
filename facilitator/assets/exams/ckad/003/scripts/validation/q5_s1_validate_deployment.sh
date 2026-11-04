#!/bin/bash
DEP=redis
if ! kubectl get deployment $DEP -n default >/dev/null 2>&1; then
  echo "Deployment $DEP not found"; exit 1
fi
REPS=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.replicas}')
IMG=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.template.spec.containers[0].image}')
LBL=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.template.metadata.labels.app}')
[ "$REPS" = "1" ] || { echo "Replicas is '$REPS', expected 1"; exit 1; }
[ "$IMG" = "redis:alpine" ] || { echo "Image is '$IMG', expected redis:alpine"; exit 1; }
[ "$LBL" = "redis" ] || { echo "Pod label app='${LBL:-none}', expected redis"; exit 1; }
echo "Deployment redis: 1 replica, redis:alpine, label app=redis"; exit 0
