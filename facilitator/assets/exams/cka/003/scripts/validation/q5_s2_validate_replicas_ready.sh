#!/bin/bash
# Validate 2 replicas are ready
READY=$(kubectl get deployment web-recovery -n image-fix -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "${READY:-0}" -lt 2 ]; then
    echo "❌ Deployment web-recovery does not have 2 ready replicas (ready: ${READY:-0})"
    kubectl get pods -n image-fix -l app=web-recovery
    exit 1
fi
echo "✅ Deployment web-recovery has 2 ready replicas"
exit 0
