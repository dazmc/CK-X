#!/bin/bash
J=$(kubectl get pod pending-pod -n pending-lab -o json 2>/dev/null) || { echo "Pod pending-pod not found in pending-lab"; exit 1; }
PH=$(echo "$J" | jq -r '.status.phase // "unknown"')
if [ "$PH" != "Running" ]; then
  echo "pod phase is '$PH', expected Running - the pod must be scheduled on k3d-cluster-agent-1 (label the node)"
  exit 1
fi
NODE=$(echo "$J" | jq -r '.spec.nodeName // "none"')
if [ "$NODE" != "k3d-cluster-agent-1" ]; then
  echo "pod runs on '$NODE', expected k3d-cluster-agent-1"
  exit 1
fi
echo "pending-pod Running on k3d-cluster-agent-1"
exit 0
