#!/bin/bash
if ! kubectl get pod frontend-site -n omni >/dev/null 2>&1; then
  echo "Pod frontend-site not found"; exit 1
fi
SA=$(kubectl get pod frontend-site -n omni -o jsonpath='{.spec.serviceAccountName}')
if [ "$SA" = "frontend-default" ]; then
  echo "Pod runs under ServiceAccount frontend-default"; exit 0
fi
echo "serviceAccountName is '${SA:-default}', expected frontend-default (the SA with no bindings/permissions)"; exit 1
