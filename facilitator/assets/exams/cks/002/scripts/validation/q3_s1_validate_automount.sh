#!/bin/bash
POD=apps-cluster-dash
if ! kubectl get pod $POD -n gamma >/dev/null 2>&1; then
  echo "Pod $POD not found"; exit 1
fi
AM=$(kubectl get pod $POD -n gamma -o jsonpath='{.spec.automountServiceAccountToken}')
if [ "$AM" = "false" ]; then
  echo "automountServiceAccountToken is false"; exit 0
fi
echo "automountServiceAccountToken is '${AM:-unset}', expected false"; exit 1
