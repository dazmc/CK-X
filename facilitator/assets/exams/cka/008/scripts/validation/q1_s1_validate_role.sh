#!/bin/bash
J=$(kubectl get role pod-manager -n rbac-test -o json 2>/dev/null) || { echo "Role pod-manager not found in rbac-test"; exit 1; }
N=$(echo "$J" | jq -r '.rules | length')
if [ "$N" != "1" ]; then
  echo "expected exactly 1 rule, found $N"
  exit 1
fi
RES=$(echo "$J" | jq -r '.rules[0].resources | join(",")')
AG=$(echo "$J" | jq -r '.rules[0].apiGroups | join(",")')
VERBS=$(echo "$J" | jq -r '.rules[0].verbs | sort | join(",")')
if [ "$RES" != "pods" ]; then
  echo "resources are '$RES', expected pods"
  exit 1
fi
case "$AG" in
  ""|"*") ;;
  *) echo "apiGroups is '$AG', expected core group ('' or '*')"; exit 1;;
esac
if [ "$VERBS" != "create,delete,get,list,watch" ]; then
  echo "verbs are '$VERBS', expected exactly create,delete,get,list,watch"
  exit 1
fi
echo "Role pod-manager grants get,list,watch,create,delete on pods"
exit 0
