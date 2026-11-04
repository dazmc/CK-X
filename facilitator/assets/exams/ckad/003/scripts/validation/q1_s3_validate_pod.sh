#!/bin/bash
POD=logger
if ! kubectl get pod $POD -n default >/dev/null 2>&1; then
  echo "Pod $POD not found"; exit 1
fi
IMG=$(kubectl get pod $POD -n default -o jsonpath='{.spec.containers[0].image}')
CLAIM=$(kubectl get pod $POD -n default -o jsonpath='{.spec.volumes[0].persistentVolumeClaim.claimName}')
MOUNT=$(kubectl get pod $POD -n default -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}')
[ "$IMG" = "nginx:alpine" ] || { echo "Image is '$IMG', expected nginx:alpine"; exit 1; }
[ "$CLAIM" = "log-claim" ] || { echo "Volume claim is '${CLAIM:-none}', expected log-claim"; exit 1; }
[ "$MOUNT" = "/var/www/nginx" ] || { echo "mountPath is '${MOUNT:-none}', expected /var/www/nginx"; exit 1; }
READY=$(kubectl get pod $POD -n default -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')
[ "$READY" = "True" ] || { echo "Pod Ready condition is '${READY:-missing}', expected True"; exit 1; }
echo "Pod logger mounts log-claim at /var/www/nginx and is Ready"; exit 0
