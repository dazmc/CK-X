#!/bin/bash
SA=system:serviceaccount:rbac-ex04:dev-sa
A=$(kubectl auth can-i delete deployments -n rbac-ex04 --as=$SA 2>/dev/null)
B=$(kubectl auth can-i list pods -n default --as=$SA 2>/dev/null)
if [ "$A" != "no" ]; then
  echo "dev-sa must NOT be able to delete deployments (answer: ${A:-none})"
  exit 1
fi
if [ "$B" != "no" ]; then
  echo "dev-sa must NOT be able to list pods outside rbac-ex04 (answer in default: ${B:-none})"
  exit 1
fi
echo "Permissions are correctly scoped"
exit 0
