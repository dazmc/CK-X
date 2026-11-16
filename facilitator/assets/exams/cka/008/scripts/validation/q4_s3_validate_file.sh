#!/bin/bash
J=$(kubectl get pod init-pod -n init-shared -o json 2>/dev/null) || { echo "Pod init-pod not found in init-shared"; exit 1; }
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
EXIT=$(echo "$J" | jq -r '.status.initContainerStatuses[0].state.terminated.exitCode // "missing"')
if [ "$EXIT" != "0" ]; then
  echo "init container exit code is '$EXIT', expected 0 (it must complete before the app starts)"
  exit 1
fi
OUT=$(kubectl exec -n init-shared init-pod -- cat /usr/share/data/init.txt 2>/dev/null)
if [ "$OUT" != "Init complete" ]; then
  echo "/usr/share/data/init.txt contains '${OUT:-nothing}', expected 'Init complete'"
  exit 1
fi
echo "Init completed and shared file written before the main container"
exit 0
