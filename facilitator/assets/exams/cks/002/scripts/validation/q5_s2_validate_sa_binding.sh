#!/bin/bash
kubectl get serviceaccount developer -n dev >/dev/null 2>&1 || { echo "ServiceAccount developer not found in dev"; exit 1; }
kubectl get rolebinding dev-write-binding -n dev >/dev/null 2>&1 || { echo "RoleBinding dev-write-binding not found in dev"; exit 1; }
ROLE=$(kubectl get rolebinding dev-write-binding -n dev -o jsonpath='{.roleRef.name}')
SUBJ=$(kubectl get rolebinding dev-write-binding -n dev -o jsonpath='{.subjects[0].name}')
SKIND=$(kubectl get rolebinding dev-write-binding -n dev -o jsonpath='{.subjects[0].kind}')
[ "$ROLE" = "dev-write" ] || { echo "roleRef is '$ROLE', expected dev-write"; exit 1; }
[ "$SUBJ" = "developer" ] || { echo "Subject is '${SUBJ:-none}', expected developer"; exit 1; }
[ "$SKIND" = "ServiceAccount" ] || { echo "Subject kind is '$SKIND', expected ServiceAccount"; exit 1; }
echo "SA developer and RoleBinding are correctly linked"; exit 0
