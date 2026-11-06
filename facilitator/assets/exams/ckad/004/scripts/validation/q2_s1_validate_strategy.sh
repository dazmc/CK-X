#!/bin/bash
D=frontend
if ! kubectl get deployment $D -n ckad-rollout >/dev/null 2>&1; then
  echo "Deployment $D not found"; exit 1
fi
T=$(kubectl get deployment $D -n ckad-rollout -o jsonpath='{.spec.strategy.type}')
MU=$(kubectl get deployment $D -n ckad-rollout -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}')
MS=$(kubectl get deployment $D -n ckad-rollout -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}')
[ "$T" = "RollingUpdate" ] || { echo "strategy type is '${T:-none}', expected RollingUpdate"; exit 1; }
[ "$MU" = "1" ] || { echo "maxUnavailable is '${MU:-none}', expected 1"; exit 1; }
[ "$MS" = "2" ] || { echo "maxSurge is '${MS:-none}', expected 2"; exit 1; }
echo "RollingUpdate maxUnavailable=1 maxSurge=2"; exit 0
