#!/bin/bash
IMG=$(kubectl get pod bad-image -n image-pull -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [ -z "$IMG" ]; then
  echo "Pod bad-image not found in image-pull"
  exit 1
fi
if [ "$IMG" != "nginx:1.27" ]; then
  echo "image is '$IMG', expected nginx:1.27"
  exit 1
fi
echo "Pod uses image nginx:1.27"
exit 0
