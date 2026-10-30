#!/bin/bash
# Validate the pod is actually scheduled on k3d-cluster-agent-1
NODE=$(kubectl get pod nginx-pod -n node-select -o jsonpath='{.spec.nodeName}' 2>/dev/null)
if [ "$NODE" != "k3d-cluster-agent-1" ]; then
    echo "❌ Pod nginx-pod is not scheduled on k3d-cluster-agent-1 (found: '${NODE:-unscheduled}')"
    exit 1
fi
PHASE=$(kubectl get pod nginx-pod -n node-select -o jsonpath='{.status.phase}')
if [ "$PHASE" != "Running" ]; then
    echo "❌ Pod nginx-pod is not Running (phase: $PHASE)"
    exit 1
fi
echo "✅ Pod nginx-pod is Running on k3d-cluster-agent-1"
exit 0
