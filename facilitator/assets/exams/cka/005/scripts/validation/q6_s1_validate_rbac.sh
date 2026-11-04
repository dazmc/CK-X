#!/bin/bash
kubectl get serviceaccount pvviewer -n default >/dev/null 2>&1 || { echo "ServiceAccount pvviewer not found"; exit 1; }
kubectl get clusterrole pvviewer-role >/dev/null 2>&1 || { echo "ClusterRole pvviewer-role not found"; exit 1; }
kubectl get clusterrolebinding pvviewer-role-binding >/dev/null 2>&1 || { echo "ClusterRoleBinding pvviewer-role-binding not found"; exit 1; }
RES=$(kubectl get clusterrole pvviewer-role -o jsonpath='{.rules[0].resources[*]}')
VERB=$(kubectl get clusterrole pvviewer-role -o jsonpath='{.rules[0].verbs[*]}')
echo "$RES" | grep -q "persistentvolumes" || { echo "ClusterRole resources are '$RES', expected persistentvolumes"; exit 1; }
echo "$VERB" | grep -qw "list" || { echo "ClusterRole verbs are '$VERB', expected to include list"; exit 1; }
SUBJ_SA=$(kubectl get clusterrolebinding pvviewer-role-binding -o jsonpath='{.subjects[0].name}')
SUBJ_KIND=$(kubectl get clusterrolebinding pvviewer-role-binding -o jsonpath='{.subjects[0].kind}')
ROLE_REF=$(kubectl get clusterrolebinding pvviewer-role-binding -o jsonpath='{.roleRef.name}')
[ "$SUBJ_KIND" = "ServiceAccount" ] || { echo "Subject kind is '$SUBJ_KIND', expected ServiceAccount"; exit 1; }
[ "$SUBJ_SA" = "pvviewer" ] || { echo "Subject name is '$SUBJ_SA', expected pvviewer"; exit 1; }
[ "$ROLE_REF" = "pvviewer-role" ] || { echo "roleRef is '$ROLE_REF', expected pvviewer-role"; exit 1; }
echo "RBAC objects exist with correct rules and binding"; exit 0
