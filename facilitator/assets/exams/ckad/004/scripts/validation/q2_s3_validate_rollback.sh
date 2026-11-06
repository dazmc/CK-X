#!/bin/bash
D=frontend
IMG=$(kubectl get deployment $D -n ckad-rollout -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
AVAIL=$(kubectl get deployment $D -n ckad-rollout -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
[ "$IMG" = "nginx:1.24-alpine" ] || { echo "image is '$IMG', expected nginx:1.24-alpine (rolled back)"; exit 1; }
[ "$AVAIL" = "4" ] || { echo "availableReplicas is '${AVAIL:-0}', expected 4"; exit 1; }
echo "Rolled back to nginx:1.24-alpine with 4 available replicas"; exit 0
