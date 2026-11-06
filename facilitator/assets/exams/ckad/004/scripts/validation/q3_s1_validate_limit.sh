#!/bin/bash
if ! kubectl get pod worker -n ckad-pod-cpu >/dev/null 2>&1; then
  echo "Pod worker not found in ckad-pod-cpu"; exit 1
fi
L=$(kubectl get pod worker -n ckad-pod-cpu -o jsonpath='{.spec.containers[0].resources.limits.cpu}')
[ "$L" = "500m" ] || { echo "limits.cpu is '${L:-none}', expected 500m (half of the LimitRange max 1 CPU)"; exit 1; }
echo "limits.cpu is 500m"; exit 0
