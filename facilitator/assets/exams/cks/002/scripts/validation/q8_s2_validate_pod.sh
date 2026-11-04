#!/bin/bash
if ! kubectl get pod busy-rx100 -n production >/dev/null 2>&1; then
  echo "Pod busy-rx100 not found in production"; exit 1
fi
IMG=$(kubectl get pod busy-rx100 -n production -o jsonpath='{.spec.containers[0].image}')
LBL=$(kubectl get pod busy-rx100 -n production -o jsonpath='{.metadata.labels.run}')
[ "$IMG" = "nginx" ] || { echo "Image is '$IMG', expected nginx"; exit 1; }
[ "$LBL" = "busy-rx100" ] || { echo "Label run='${LBL:-none}', expected busy-rx100"; exit 1; }
echo "Pod exists with image nginx and label run=busy-rx100"; exit 0
