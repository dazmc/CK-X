#!/bin/bash
DEP=nginx-deploy
if ! kubectl get deployment $DEP -n default >/dev/null 2>&1; then
  echo "Deployment $DEP not found"; exit 1
fi
REPS=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.replicas}')
MS=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}')
MU=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}')
[ "$REPS" = "4" ] || { echo "Replicas is '$REPS', expected 4"; exit 1; }
[ "$MS" = "1" ] || { echo "maxSurge is '${MS:-none}', expected 1"; exit 1; }
[ "$MU" = "2" ] || { echo "maxUnavailable is '${MU:-none}', expected 2"; exit 1; }
echo "4 replicas with RollingUpdate maxSurge=1 maxUnavailable=2"; exit 0
