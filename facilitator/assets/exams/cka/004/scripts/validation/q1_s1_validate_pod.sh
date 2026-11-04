#!/bin/bash
# Validate pod nginx-pod: image and label
NS=default; NAME=nginx-pod
if ! kubectl get pod $NAME -n $NS >/dev/null 2>&1; then
  echo "Pod $NAME not found in namespace $NS"; exit 1
fi
IMG=$(kubectl get pod $NAME -n $NS -o jsonpath='{.spec.containers[0].image}')
if [ "$IMG" != "nginx:alpine" ]; then
  echo "Image is '$IMG', expected nginx:alpine"; exit 1
fi
RUN=$(kubectl get pod $NAME -n $NS -o jsonpath='{.metadata.labels.run}')
if [ "$RUN" != "nginx-pod" ]; then
  echo "Label run='$RUN', expected nginx-pod"; exit 1
fi
echo "Pod exists with correct image and label"; exit 0
