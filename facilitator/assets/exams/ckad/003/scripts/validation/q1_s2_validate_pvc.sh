#!/bin/bash
PVC=log-claim
if ! kubectl get pvc $PVC -n default >/dev/null 2>&1; then
  echo "PersistentVolumeClaim $PVC not found"; exit 1
fi
SIZE=$(kubectl get pvc $PVC -n default -o jsonpath='{.spec.resources.requests.storage}')
MODE=$(kubectl get pvc $PVC -n default -o jsonpath='{.spec.accessModes[0]}')
SC=$(kubectl get pvc $PVC -n default -o jsonpath='{.spec.storageClassName}')
PHASE=$(kubectl get pvc $PVC -n default -o jsonpath='{.status.phase}')
VOL=$(kubectl get pvc $PVC -n default -o jsonpath='{.spec.volumeName}')
[ "$SIZE" = "200Mi" ] || { echo "Requested storage is '$SIZE', expected 200Mi"; exit 1; }
[ "$MODE" = "ReadWriteMany" ] || { echo "Access mode is '$MODE', expected ReadWriteMany"; exit 1; }
[ "$SC" = "manual" ] || { echo "storageClassName is '$SC', expected manual"; exit 1; }
[ "$PHASE" = "Bound" ] || { echo "PVC phase is '$PHASE', expected Bound"; exit 1; }
[ "$VOL" = "log-volume" ] || { echo "PVC bound to '${VOL:-nothing}', expected log-volume"; exit 1; }
echo "PVC log-claim is Bound to log-volume"; exit 0
