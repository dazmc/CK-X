#!/bin/bash
SC=$(kubectl get pvc local-pvc -n wffc-ex25 -o jsonpath='{.spec.storageClassName}' 2>/dev/null)
SZ=$(kubectl get pvc local-pvc -n wffc-ex25 -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)
AM=$(kubectl get pvc local-pvc -n wffc-ex25 -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null)
PH=$(kubectl get pvc local-pvc -n wffc-ex25 -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$SC" != "local-wffc" ]; then
  echo "PVC storageClassName is '${SC:-none}', expected local-wffc"
  exit 1
fi
case "$SZ" in
  1Gi|1024Mi) ;;
  *) echo "PVC size is '${SZ:-none}', expected 1Gi"; exit 1;;
esac
if [ "$AM" != "ReadWriteOnce" ]; then
  echo "PVC accessMode is '${AM:-none}', expected ReadWriteOnce"
  exit 1
fi
if [ "$PH" != "Bound" ]; then
  echo "PVC phase is '${PH:-none}', expected Bound (create the consuming Pod)"
  exit 1
fi
echo "PVC local-pvc is Bound (1Gi ReadWriteOnce on local-wffc)"
exit 0
