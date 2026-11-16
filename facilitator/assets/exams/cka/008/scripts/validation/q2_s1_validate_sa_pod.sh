#!/bin/bash
if ! kubectl get sa app-sa -n sa-token >/dev/null 2>&1; then
  echo "ServiceAccount app-sa not found in sa-token"
  exit 1
fi
SA=$(kubectl get pod sa-pod -n sa-token -o jsonpath='{.spec.serviceAccountName}' 2>/dev/null)
if [ "$SA" != "app-sa" ]; then
  echo "pod sa-pod uses serviceAccountName '${SA:-none}', expected app-sa"
  exit 1
fi
echo "ServiceAccount app-sa exists and sa-pod runs under it"
exit 0
