#!/bin/bash
A=$(kubectl auth can-i list nodes --as=system:serviceaccount:rbac-ex04:dev-sa 2>/dev/null)
if [ "$A" != "yes" ]; then
  echo "dev-sa cannot list nodes (answer: ${A:-none}) - check ClusterRole node-viewer and ClusterRoleBinding dev-node-access"
  exit 1
fi
echo "dev-sa can list nodes"
exit 0
