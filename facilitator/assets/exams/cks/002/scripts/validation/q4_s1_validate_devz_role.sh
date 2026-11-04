#!/bin/bash
V=$(kubectl get role dev-user-access -n dev-z -o jsonpath='{.rules[0].verbs[*]}' 2>/dev/null)
RES=$(kubectl get role dev-user-access -n dev-z -o jsonpath='{.rules[0].resources[*]}' 2>/dev/null)
if [ -z "$V" ]; then echo "Role dev-user-access in dev-z not found"; exit 1; fi
SORTED=$(echo $V | tr ' ' '\n' | sort | tr '\n' ' ')
echo "$SORTED" | grep -qw get || { echo "Role missing verb 'get' (have: $V)"; exit 1; }
echo "$SORTED" | grep -qw list || { echo "Role missing verb 'list' (have: $V)"; exit 1; }
for BAD in create delete update patch watch deletecollection; do
  echo "$SORTED" | grep -qw "$BAD" && { echo "Role still grants '$BAD' (have: $V)"; exit 1; }
done
echo "$RES" | grep -qw pods || { echo "Role resources are '$RES', expected pods"; exit 1; }
echo "dev-z role grants only get,list on pods"; exit 0
