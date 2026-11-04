#!/bin/bash
POD=pvviewer
if ! kubectl get pod $POD -n default >/dev/null 2>&1; then
  echo "Pod $POD not found"; exit 1
fi
SA=$(kubectl get pod $POD -n default -o jsonpath='{.spec.serviceAccountName}')
if [ "$SA" = "pvviewer" ]; then
  echo "Pod runs under ServiceAccount pvviewer"; exit 0
fi
echo "serviceAccountName is '${SA:-default}', expected pvviewer"; exit 1
