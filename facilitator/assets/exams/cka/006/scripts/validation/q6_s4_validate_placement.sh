#!/bin/bash
NODES=$(kubectl get pods -n drain-ex08 -l app=drain-demo -o jsonpath='{.items[*].spec.nodeName}' 2>/dev/null)
if ! echo "$NODES" | tr ' ' '\n' | grep -qx "k3d-cluster-agent-1"; then
  echo "No drain-demo pod runs on k3d-cluster-agent-1 (pods on: ${NODES:-none})"
  exit 1
fi
echo "drain-demo pods include k3d-cluster-agent-1"
exit 0
