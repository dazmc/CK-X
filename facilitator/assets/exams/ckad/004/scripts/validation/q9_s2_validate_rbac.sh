#!/bin/bash
V1=$(kubectl get role read-pods -n ckad-rbac -o jsonpath='{.rules[0].verbs[*]}' 2>/dev/null)
R1=$(kubectl get role read-pods -n ckad-rbac -o jsonpath='{.rules[0].resources[*]}' 2>/dev/null)
V2=$(kubectl get role read-pod-logs -n ckad-rbac -o jsonpath='{.rules[0].verbs[*]}' 2>/dev/null)
R2=$(kubectl get role read-pod-logs -n ckad-rbac -o jsonpath='{.rules[0].resources[*]}' 2>/dev/null)
B1=$(kubectl get rolebinding pod-reader-binding -n ckad-rbac -o jsonpath='{.subjects[0].name}' 2>/dev/null)
B2=$(kubectl get rolebinding log-reader-binding -n ckad-rbac -o jsonpath='{.subjects[0].name}' 2>/dev/null)
SORTED1=$(echo $V1 | tr ' ' '\n' | sort | tr '\n' ' ')
echo "$SORTED1" | grep -qw get || { echo "read-pods verbs changed (have: $V1)"; exit 1; }
echo "$SORTED1" | grep -qw list || { echo "read-pods missing list (have: $V1)"; exit 1; }
for BAD in create delete update patch; do
  echo "$SORTED1" | grep -qw "$BAD" && { echo "read-pods now grants '$BAD' (have: $V1)"; exit 1; }
done
echo "$R1" | grep -qw pods || { echo "read-pods resources changed (have: $R1)"; exit 1; }
[ "$V2" = "get" ] || { echo "read-pod-logs verbs changed (have: $V2)"; exit 1; }
echo "$R2" | grep -q "pods/log" || { echo "read-pod-logs resources changed (have: $R2)"; exit 1; }
[ "$B1" = "pod-reader" ] || { echo "pod-reader-binding subject changed (have: $B1)"; exit 1; }
[ "$B2" = "log-reader" ] || { echo "log-reader-binding subject changed (have: $B2)"; exit 1; }
echo "Roles and RoleBindings unchanged"; exit 0
