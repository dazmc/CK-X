#!/bin/bash
# Setup for Question 3: Node labeling and nodeSelector
kubectl create namespace node-select --dry-run=client -o yaml | kubectl apply -f -
# Remove any label left over from a previous run
kubectl label node k3d-cluster-agent-1 disk- 2>/dev/null || true
exit 0
