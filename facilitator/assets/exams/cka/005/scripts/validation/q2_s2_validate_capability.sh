#!/bin/bash
CAPS=$(kubectl get pod super-user-pod -n default -o jsonpath='{.spec.containers[0].securityContext.capabilities.add[*]}' 2>/dev/null)
if echo "$CAPS" | grep -qw "SYS_TIME"; then
  echo "SYS_TIME capability added: $CAPS"; exit 0
fi
echo "capabilities.add is '${CAPS:-none}', expected to include SYS_TIME"; exit 1
