#!/bin/bash
NS=default; NAME=super-user-pod
if ! kubectl get pod $NAME -n $NS >/dev/null 2>&1; then
  echo "Pod $NAME not found in namespace $NS"; exit 1
fi
IMG=$(kubectl get pod $NAME -n $NS -o jsonpath='{.spec.containers[0].image}')
CMD=$(kubectl get pod $NAME -n $NS -o jsonpath='{.spec.containers[0].command[*]}')
[ "$IMG" = "busybox:1.28" ] || { echo "Image is '$IMG', expected busybox:1.28"; exit 1; }
echo "$CMD" | grep -q "sleep" || { echo "Command does not contain sleep: '$CMD'"; exit 1; }
echo "$CMD" | grep -q "4800" || { echo "Command does not sleep 4800: '$CMD'"; exit 1; }
echo "Pod exists with correct image and command"; exit 0
