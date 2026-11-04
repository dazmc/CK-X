#!/bin/bash
POD=multi-pod
if ! kubectl get pod $POD -n default >/dev/null 2>&1; then
  echo "Pod $POD not found"; exit 1
fi
NAMES=$(kubectl get pod $POD -n default -o jsonpath='{.spec.containers[*].name}')
echo "$NAMES" | grep -qw alpha || { echo "Container alpha missing (have: $NAMES)"; exit 1; }
echo "$NAMES" | grep -qw beta || { echo "Container beta missing (have: $NAMES)"; exit 1; }
echo "Both containers present"; exit 0
