#!/bin/bash
# Validate pod nginx-pod exists in namespace node-select with nodeSelector
kubectl get pod nginx-pod -n node-select &>/dev/null || {
    echo "❌ Pod nginx-pod not found in namespace node-select"
    exit 1
}
SELECTOR=$(kubectl get pod nginx-pod -n node-select -o jsonpath='{.spec.nodeSelector.disk}')
if [ "$SELECTOR" != "ssd" ]; then
    echo "❌ Pod nginx-pod does not have nodeSelector disk=ssd (found: '${SELECTOR:-none}')"
    exit 1
fi
echo "✅ Pod nginx-pod exists with nodeSelector disk=ssd"
exit 0
