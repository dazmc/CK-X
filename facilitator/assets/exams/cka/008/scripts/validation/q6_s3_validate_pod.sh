#!/bin/bash
J=$(kubectl get pod storage-pod -n dynamic-storage -o json 2>/dev/null) || { echo "Pod storage-pod not found in dynamic-storage"; exit 1; }
PH=$(echo "$J" | jq -r '.status.phase // "unknown"')
if [ "$PH" != "Running" ]; then
  echo "pod phase is '$PH', expected Running"
  exit 1
fi
VN=$(echo "$J" | jq -r '[.spec.containers[].volumeMounts[]? | select(.mountPath=="/data")][0].name // ""')
if [ -z "$VN" ]; then
  echo "no container mounts a volume at /data"
  exit 1
fi
CLAIM=$(echo "$J" | jq -r --arg n "$VN" '[.spec.volumes[] | select(.name==$n) | .persistentVolumeClaim.claimName] | first // ""')
if [ "$CLAIM" != "dynamic-pvc" ]; then
  echo "volume at /data is backed by '${CLAIM:-nothing}', expected PVC dynamic-pvc"
  exit 1
fi
echo "storage-pod Running with dynamic-pvc mounted at /data"
exit 0
