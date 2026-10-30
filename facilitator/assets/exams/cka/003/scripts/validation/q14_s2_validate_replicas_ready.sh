#!/bin/bash
# Validate 4 replicas exist and are ready
READY=$(kubectl get deployment spread-app -n spread -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "${READY:-0}" -lt 4 ]; then
    echo "❌ Deployment spread-app should have 4 ready replicas (ready: ${READY:-0})"
    kubectl get pods -n spread -l app=spread-app -o wide
    exit 1
fi
echo "✅ Deployment spread-app has 4 ready replicas"
exit 0
