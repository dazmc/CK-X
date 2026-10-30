#!/bin/bash
# Validate critical-app has 3 ready replicas
READY=$(kubectl get deployment critical-app -n maintenance -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "${READY:-0}" -lt 3 ]; then
    echo "❌ Deployment critical-app should have 3 ready replicas (ready: ${READY:-0})"
    kubectl get pods -n maintenance -l app=critical-app
    kubectl get nodes
    exit 1
fi
echo "✅ Deployment critical-app has 3 ready replicas"
exit 0
