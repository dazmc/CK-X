#!/bin/bash
IMG=$(kubectl get deploy webapp -n rollout-ex06 -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$IMG" != "nginx:1.27" ]; then
  echo "current image is '${IMG:-none}', expected nginx:1.27 (after the rollback)"
  exit 1
fi
REVS=$(kubectl rollout history deployment webapp -n rollout-ex06 2>/dev/null | awk 'NR>1 && $1 ~ /^[0-9]+$/' | wc -l)
if [ "$REVS" -lt 2 ]; then
  echo "rollout history has $REVS revision(s), expected at least 2 (image update + rollback)"
  exit 1
fi
OLD=$(kubectl get rs -n rollout-ex06 -l app=webapp -o json 2>/dev/null | jq -r '[.items[] | select(.spec.template.spec.containers[0].image=="nginx:1.28")] | length')
if [ "${OLD:-0}" -lt 1 ]; then
  echo "no ReplicaSet with the intermediate image nginx:1.28 found - the image update step was skipped"
  exit 1
fi
echo "Rolled back to nginx:1.27 ($REVS revisions, intermediate nginx:1.28 ReplicaSet present)"
exit 0
