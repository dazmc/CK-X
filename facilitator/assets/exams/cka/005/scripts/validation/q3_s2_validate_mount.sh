#!/bin/bash
POD=use-pv
if ! kubectl get pod $POD -n default >/dev/null 2>&1; then
  echo "Pod $POD not found"; exit 1
fi
CLAIM=$(kubectl get pod $POD -n default -o jsonpath='{.spec.volumes[0].persistentVolumeClaim.claimName}')
MOUNT=$(kubectl get pod $POD -n default -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}')
[ "$CLAIM" = "my-pvc" ] || { echo "Volume claim is '${CLAIM:-none}', expected my-pvc"; exit 1; }
[ "$MOUNT" = "/data" ] || { echo "mountPath is '${MOUNT:-none}', expected /data"; exit 1; }
echo "Pod mounts claim my-pvc at /data"; exit 0
