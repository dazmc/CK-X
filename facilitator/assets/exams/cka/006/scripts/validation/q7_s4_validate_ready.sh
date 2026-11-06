#!/bin/bash
R=$(kubectl get deploy webapp -n rollout-ex06 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "${R:-0}" -ne 3 ]; then
  echo "webapp has ${R:-0} ready replicas, expected 3"
  exit 1
fi
echo "All 3 webapp replicas are ready"
exit 0
