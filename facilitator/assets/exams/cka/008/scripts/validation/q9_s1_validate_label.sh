#!/bin/bash
L=$(kubectl get node k3d-cluster-agent-1 -o jsonpath='{.metadata.labels.workload}' 2>/dev/null)
if [ "$L" != "batch" ]; then
  echo "node k3d-cluster-agent-1 label workload is '${L:-none}', expected batch (kubectl label node k3d-cluster-agent-1 workload=batch)"
  exit 1
fi
echo "Node k3d-cluster-agent-1 carries workload=batch"
exit 0
