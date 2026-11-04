#!/bin/bash
NS=finance; NAME=temp-bus
if ! kubectl get pod $NAME -n $NS >/dev/null 2>&1; then
  echo "Pod $NAME not found in namespace $NS"; exit 1
fi
IMG=$(kubectl get pod $NAME -n $NS -o jsonpath='{.spec.containers[0].image}')
if [ "$IMG" != "redis:alpine" ]; then
  echo "Image is '$IMG', expected redis:alpine"; exit 1
fi
echo "Pod exists in finance with correct image"; exit 0
