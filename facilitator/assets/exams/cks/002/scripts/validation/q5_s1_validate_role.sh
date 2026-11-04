#!/bin/bash
if ! kubectl get role dev-write -n dev >/dev/null 2>&1; then
  echo "Role dev-write not found in dev"; exit 1
fi
V=$(kubectl get role dev-write -n dev -o jsonpath='{.rules[0].verbs[*]}')
RES=$(kubectl get role dev-write -n dev -o jsonpath='{.rules[0].resources[*]}')
SORTED=$(echo $V | tr ' ' '\n' | sort | tr '\n' ' ')
for NEED in create get list watch; do
  echo "$SORTED" | grep -qw "$NEED" || { echo "Role missing verb '$NEED' (have: $V)"; exit 1; }
done
for BAD in delete update patch deletecollection; do
  echo "$SORTED" | grep -qw "$BAD" && { echo "Role unexpectedly grants '$BAD' (have: $V)"; exit 1; }
done
echo "$RES" | grep -qw pods || { echo "Role resources are '$RES', expected pods"; exit 1; }
echo "Role dev-write is correct"; exit 0
