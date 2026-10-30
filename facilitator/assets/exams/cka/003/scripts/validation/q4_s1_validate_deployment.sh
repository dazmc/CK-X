#!/bin/bash
# Validate deployment web-app exists with 2 replicas
kubectl get deployment web-app -n nodeport-lab &>/dev/null || {
    echo "❌ Deployment web-app not found in namespace nodeport-lab"
    exit 1
}
REPLICAS=$(kubectl get deployment web-app -n nodeport-lab -o jsonpath='{.spec.replicas}')
READY=$(kubectl get deployment web-app -n nodeport-lab -o jsonpath='{.status.readyReplicas}')
if [ "$REPLICAS" != "2" ]; then
    echo "❌ Deployment web-app should have 2 replicas (found: $REPLICAS)"
    exit 1
fi
if [ "${READY:-0}" -lt 2 ]; then
    echo "❌ Deployment web-app does not have 2 ready replicas (ready: ${READY:-0})"
    exit 1
fi
echo "✅ Deployment web-app exists with 2 ready replicas"
exit 0
