#!/bin/bash
A=$(kubectl auth can-i patch deployments --subresource=scale -n rbac-ex04 --as=system:serviceaccount:rbac-ex04:dev-sa 2>/dev/null)
if [ "$A" != "yes" ]; then
  echo "dev-sa cannot patch deployments/scale (answer: ${A:-none}) - the Role must grant patch on the deployments/scale subresource"
  exit 1
fi
echo "dev-sa can patch deployments/scale"
exit 0
