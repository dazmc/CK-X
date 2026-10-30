#!/bin/bash
# Validate PVC requests 5Gi
STORAGE=$(kubectl get pvc data-pvc -n storage-expand -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)
if [ "$STORAGE" != "5Gi" ]; then
    echo "❌ PVC data-pvc should request 5Gi (found: '${STORAGE:-none}')"
    exit 1
fi
echo "✅ PVC data-pvc requests 5Gi"
exit 0
