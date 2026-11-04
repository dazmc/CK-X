#!/bin/bash
if kubectl get pod orange -n default >/dev/null 2>&1; then
  echo "Pod orange exists"; exit 0
fi
echo "Pod orange not found in namespace default"; exit 1
