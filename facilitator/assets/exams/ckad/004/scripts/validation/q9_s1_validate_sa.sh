#!/bin/bash
SA=$(kubectl get deployment inspector -n ckad-rbac -o jsonpath='{.spec.template.spec.serviceAccountName}' 2>/dev/null)
if [ "$SA" = "pod-reader" ]; then echo "inspector uses serviceAccountName pod-reader"; exit 0; fi
echo "serviceAccountName is '${SA:-default}', expected pod-reader"; exit 1
