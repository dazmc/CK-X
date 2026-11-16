#!/bin/bash
J=$(kubectl get pod init-pod -n init-shared -o json 2>/dev/null) || { echo "Pod init-pod not found in init-shared"; exit 1; }
N=$(echo "$J" | jq -r '.spec.initContainers | length')
if [ "${N:-0}" -lt 1 ]; then
  echo "pod has no initContainers - the init container must run before the main container"
  exit 1
fi
NAME=$(echo "$J" | jq -r '.spec.initContainers[0].name // "missing"')
IMG=$(echo "$J" | jq -r '.spec.initContainers[0].image // "missing"')
CMD=$(echo "$J" | jq -r '[.spec.initContainers[0] | ((.command // []) + (.args // []))[]] | join(" ")')
if [ "$NAME" != "init-container" ]; then
  echo "init container name is '$NAME', expected init-container"
  exit 1
fi
if [ "$IMG" != "busybox:1.36" ]; then
  echo "init container image is '$IMG', expected busybox:1.36"
  exit 1
fi
if ! echo "$CMD" | grep -q "/shared/init.txt"; then
  echo "init container command is '$CMD', expected to write /shared/init.txt"
  exit 1
fi
if ! echo "$CMD" | grep -q "Init complete"; then
  echo "init container command is '$CMD', expected to echo 'Init complete'"
  exit 1
fi
echo "Init container init-container defined correctly"
exit 0
