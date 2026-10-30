#!/bin/bash
# Validate the dedicated=critical taint is no longer present
TAINTS=$(kubectl get node k3d-cluster-agent-1 -o jsonpath='{.spec.taints[*].key}' 2>/dev/null)
if echo "$TAINTS" | grep -qw "dedicated"; then
    echo "❌ Node k3d-cluster-agent-1 still has the 'dedicated' taint"
    exit 1
fi
echo "✅ The dedicated=critical taint has been removed"
exit 0
