#!/bin/bash
PVC=my-pvc
if ! kubectl get pvc $PVC -n default >/dev/null 2>&1; then
  echo "PersistentVolumeClaim $PVC not found"; exit 1
fi
MODE=$(kubectl get pvc $PVC -n default -o jsonpath='{.spec.accessModes[0]}')
SIZE=$(kubectl get pvc $PVC -n default -o jsonpath='{.spec.resources.requests.storage}')
PHASE=$(kubectl get pvc $PVC -n default -o jsonpath='{.status.phase}')
[ "$MODE" = "ReadWriteOnce" ] || { echo "Access mode is '$MODE', expected ReadWriteOnce"; exit 1; }
[ "$SIZE" = "10Mi" ] || { echo "Requested storage is '$SIZE', expected 10Mi"; exit 1; }
[ "$PHASE" = "Bound" ] || { echo "PVC phase is '$PHASE', expected Bound"; exit 1; }
echo "PVC exists (ReadWriteOnce, 10Mi) and is Bound"; exit 0
