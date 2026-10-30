#!/bin/bash
# Validate node k3d-cluster-agent-1 is labeled disk=ssd
VALUE=$(kubectl get node k3d-cluster-agent-1 -o jsonpath='{.metadata.labels.disk}' 2>/dev/null)
if [ "$VALUE" != "ssd" ]; then
    echo "❌ Node k3d-cluster-agent-1 is not labeled disk=ssd (found: '${VALUE:-none}')"
    exit 1
fi
echo "✅ Node k3d-cluster-agent-1 is labeled disk=ssd"
exit 0
