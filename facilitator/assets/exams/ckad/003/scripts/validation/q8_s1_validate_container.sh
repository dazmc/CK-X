#!/bin/bash
POD=my-busybox
if ! kubectl get pod $POD -n dev2406 >/dev/null 2>&1; then
  echo "Pod $POD not found in namespace dev2406"; exit 1
fi
NAME=$(kubectl get pod $POD -n dev2406 -o jsonpath='{.spec.containers[0].name}')
IMG=$(kubectl get pod $POD -n dev2406 -o jsonpath='{.spec.containers[0].image}')
CMD=$(kubectl get pod $POD -n dev2406 -o jsonpath='{.spec.containers[0].command[*]}')
[ "$NAME" = "secret" ] || { echo "Container name is '$NAME', expected secret"; exit 1; }
[ "$IMG" = "busybox" ] || { echo "Image is '$IMG', expected busybox"; exit 1; }
echo "$CMD" | grep -q "sleep" && echo "$CMD" | grep -q "3600" || { echo "Command does not sleep 3600: '$CMD'"; exit 1; }
echo "Container secret runs sleep 3600"; exit 0
