#!/bin/bash
CMD=$(kubectl get pod orange -n default -o jsonpath='{.spec.containers[0].command[*]}' 2>/dev/null)
if echo "$CMD" | grep -q "sleeeep"; then
  echo "Command still contains the typo: $CMD"; exit 1
fi
if echo "$CMD" | grep -q "sleep"; then
  echo "Command corrected: $CMD"; exit 0
fi
echo "Command does not contain sleep: '$CMD'"; exit 1
