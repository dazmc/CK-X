#!/bin/bash
J=$(kubectl get pod init-pod -n init-shared -o json 2>/dev/null) || { echo "Pod init-pod not found in init-shared"; exit 1; }
if ! echo "$J" | jq -e '.spec.volumes[] | select(.name=="shared-vol") | has("emptyDir")' >/dev/null; then
  echo "volume shared-vol must exist as an emptyDir"
  exit 1
fi
if ! echo "$J" | jq -e '.spec.initContainers[0].volumeMounts[]? | select(.name=="shared-vol" and .mountPath=="/shared")' >/dev/null; then
  echo "init container must mount shared-vol at /shared"
  exit 1
fi
MNAME=$(echo "$J" | jq -r '[.spec.containers[].volumeMounts[]? | select(.mountPath=="/usr/share/data")][0].name // ""')
if [ "$MNAME" != "shared-vol" ]; then
  echo "main container does not mount shared-vol at /usr/share/data (got '${MNAME:-nothing}')"
  exit 1
fi
echo "emptyDir shared-vol mounted by both containers at the required paths"
exit 0
