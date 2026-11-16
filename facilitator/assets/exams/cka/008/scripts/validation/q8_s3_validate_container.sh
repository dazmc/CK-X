#!/bin/bash
J=$(kubectl get pod bad-image -n image-pull -o json 2>/dev/null) || { echo "Pod bad-image not found in image-pull"; exit 1; }
N=$(echo "$J" | jq -r '.spec.containers | length')
if [ "$N" != "1" ]; then
  echo "pod has $N containers, expected exactly 1"
  exit 1
fi
C=$(echo "$J" | jq -r '.spec.containers[0].name')
if [ "$C" != "bad-image" ]; then
  echo "container name is '$C', expected bad-image"
  exit 1
fi
echo "Single container named bad-image"
exit 0
