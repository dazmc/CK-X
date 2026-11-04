#!/bin/bash
NS=default; NAME=non-root-pod
if ! kubectl get pod $NAME -n $NS >/dev/null 2>&1; then
  echo "Pod $NAME not found in namespace $NS"; exit 1
fi
IMG=$(kubectl get pod $NAME -n $NS -o jsonpath='{.spec.containers[0].image}')
[ "$IMG" = "redis:alpine" ] || { echo "Image is '$IMG', expected redis:alpine"; exit 1; }
echo "Pod exists with correct image"; exit 0
