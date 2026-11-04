#!/bin/bash
NS=default; NAME=messaging
if ! kubectl get pod $NAME -n $NS >/dev/null 2>&1; then
  echo "Pod $NAME not found in namespace $NS"; exit 1
fi
IMG=$(kubectl get pod $NAME -n $NS -o jsonpath='{.spec.containers[0].image}')
if [ "$IMG" != "redis:alpine" ]; then
  echo "Image is '$IMG', expected redis:alpine"; exit 1
fi
TIER=$(kubectl get pod $NAME -n $NS -o jsonpath='{.metadata.labels.tier}')
if [ "$TIER" != "msg" ]; then
  echo "Label tier='$TIER', expected msg"; exit 1
fi
echo "Pod exists with correct image and label"; exit 0
