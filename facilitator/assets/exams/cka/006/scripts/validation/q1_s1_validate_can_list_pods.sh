#!/bin/bash
A=$(kubectl auth can-i list pods -n rbac-ex04 --as=system:serviceaccount:rbac-ex04:dev-sa 2>/dev/null)
if [ "$A" != "yes" ]; then
  echo "dev-sa cannot list pods in rbac-ex04 (answer: ${A:-none})"
  exit 1
fi
echo "dev-sa can list pods in rbac-ex04"
exit 0
