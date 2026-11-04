#!/bin/bash
for NS in dev-a dev-b dev-z; do
  SUBJ=$(kubectl get rolebinding dev-user-access -n $NS -o jsonpath='{.subjects[0].name}' 2>/dev/null)
  [ "$SUBJ" = "martin" ] || { echo "RoleBinding in $NS subject is '${SUBJ:-missing}', expected martin"; exit 1; }
done
echo "RoleBindings still bind dev-user-access to martin"; exit 0
