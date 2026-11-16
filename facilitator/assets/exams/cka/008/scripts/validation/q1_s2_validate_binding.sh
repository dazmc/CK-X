#!/bin/bash
J=$(kubectl get rolebinding pod-manager-binding -n rbac-test -o json 2>/dev/null) || { echo "RoleBinding pod-manager-binding not found in rbac-test"; exit 1; }
RN=$(echo "$J" | jq -r '.roleRef.name // "missing"')
RK=$(echo "$J" | jq -r '.roleRef.kind // "missing"')
if [ "$RN" != "pod-manager" ] || [ "$RK" != "Role" ]; then
  echo "roleRef is $RK/$RN, expected Role/pod-manager"
  exit 1
fi
if ! echo "$J" | jq -e '[.subjects[]? | select(.kind=="User" and .name=="alice")] | length >= 1' >/dev/null; then
  SUBS=$(echo "$J" | jq -r '[.subjects[]? | "\(.kind)/\(.name)"] | join(", ")')
  echo "subjects are '${SUBS:-none}', expected a User subject alice"
  exit 1
fi
echo "RoleBinding binds Role pod-manager to user alice"
exit 0
