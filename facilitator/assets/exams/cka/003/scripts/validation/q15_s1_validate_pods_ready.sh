#!/bin/bash
# Validate all 3 shop pods are Ready
READY=$(kubectl get deployment shop -n repair -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "${READY:-0}" -lt 3 ]; then
    echo "❌ Deployment shop should have 3 ready replicas (ready: ${READY:-0})"
    kubectl get pods -n repair -l app=shop
    exit 1
fi
echo "✅ Deployment shop has 3 ready replicas"
exit 0
