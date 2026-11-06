#!/bin/bash
CMD=$(kubectl get job cleanup-job -n job-ex21 -o json 2>/dev/null | jq -r '[.spec.template.spec.containers[0] | ((.command // []) + (.args // []))[]] | join(" ")')
if ! echo "$CMD" | grep -q "Cleanup complete"; then
  echo "command is '${CMD:-none}', expected to contain 'Cleanup complete'"
  exit 1
fi
echo "Job command contains 'Cleanup complete'"
exit 0
