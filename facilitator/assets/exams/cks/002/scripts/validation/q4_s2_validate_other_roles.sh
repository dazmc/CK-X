#!/bin/bash
for NS in dev-a dev-b; do
  V=$(kubectl get role dev-user-access -n $NS -o jsonpath='{.rules[0].verbs[*]}' 2>/dev/null)
  echo "$V" | grep -qw '*' || { echo "Role in $NS was changed - expected full access '*', have '$V'"; exit 1; }
done
echo "Roles in dev-a and dev-b unchanged"; exit 0
