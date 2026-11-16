#!/bin/bash
PH=$(kubectl get pod sa-pod -n sa-token -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$PH" != "Running" ]; then
  echo "pod phase is '${PH:-none}', expected Running"
  exit 1
fi
IMG=$(kubectl get pod sa-pod -n sa-token -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [ "$IMG" != "nginx:1.27" ]; then
  echo "image is '${IMG:-none}', expected nginx:1.27"
  exit 1
fi
echo "Pod sa-pod Running with image nginx:1.27"
exit 0
