#!/bin/bash
if ! kubectl get pod dev-pod -n dev >/dev/null 2>&1; then
  echo "Pod dev-pod not found in dev"; exit 1
fi
SA=$(kubectl get pod dev-pod -n dev -o jsonpath='{.spec.serviceAccountName}')
if [ "$SA" = "developer" ]; then
  echo "Pod runs under ServiceAccount developer"; exit 0
fi
echo "serviceAccountName is '${SA:-default}', expected developer"; exit 1
