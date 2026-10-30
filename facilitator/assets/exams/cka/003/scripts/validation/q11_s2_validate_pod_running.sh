#!/bin/bash
# Validate app-crasher is Ready (its readiness probe now passes)
READY=$(kubectl get pod app-crasher -n debug-pod -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
if [ "$READY" != "True" ]; then
    echo "❌ Pod app-crasher is not Ready (Ready condition: ${READY:-unknown})"
    kubectl get pod app-crasher -n debug-pod
    kubectl describe pod app-crasher -n debug-pod | tail -10
    exit 1
fi
echo "✅ Pod app-crasher is Ready"
exit 0
