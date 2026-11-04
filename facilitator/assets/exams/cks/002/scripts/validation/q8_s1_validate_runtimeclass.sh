#!/bin/bash
if ! kubectl get pod busy-rx100 -n production >/dev/null 2>&1; then
  echo "Pod busy-rx100 not found"; exit 1
fi
RC=$(kubectl get pod busy-rx100 -n production -o jsonpath='{.spec.runtimeClassName}')
if [ "$RC" = "gvisor" ]; then
  echo "runtimeClassName is gvisor"; exit 0
fi
echo "runtimeClassName is '${RC:-unset}', expected gvisor"; exit 1
