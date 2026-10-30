#!/bin/bash
# Validate the node is schedulable again
UNSCHEDULABLE=$(kubectl get node k3d-cluster-agent-1 -o jsonpath='{.spec.unschedulable}' 2>/dev/null)
if [ "$UNSCHEDULABLE" == "true" ]; then
    echo "❌ Node k3d-cluster-agent-1 is still cordoned"
    exit 1
fi
echo "✅ Node k3d-cluster-agent-1 is uncordoned"
exit 0
