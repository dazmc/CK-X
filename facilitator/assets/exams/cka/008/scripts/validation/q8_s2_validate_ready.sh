#!/bin/bash
J=$(kubectl get pod bad-image -n image-pull -o json 2>/dev/null) || { echo "Pod bad-image not found in image-pull"; exit 1; }
PH=$(echo "$J" | jq -r '.status.phase // "unknown"')
if [ "$PH" != "Running" ]; then
  echo "pod phase is '$PH', expected Running"
  exit 1
fi
READY=$(echo "$J" | jq -r '[.status.conditions[]? | select(.type=="Ready") | .status] | first // "False"')
if [ "$READY" != "True" ]; then
  echo "pod Ready condition is '$READY', expected True"
  exit 1
fi
echo "Pod bad-image Running and Ready"
exit 0
