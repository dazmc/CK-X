#!/bin/bash
A=$(kubectl get deploy webapp -n rollout-ex06 -o jsonpath='{.metadata.annotations.kubernetes\.io/change-cause}' 2>/dev/null)
if [ -z "$A" ]; then
  echo "annotation kubernetes.io/change-cause is not set on the Deployment"
  exit 1
fi
echo "change-cause annotation: $A"
exit 0
