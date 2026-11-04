#!/bin/bash
if kubectl get pod triton -n alpha >/dev/null 2>&1; then
  echo "Pod triton (readOnlyRootFilesystem absent = mutable) still exists"; exit 1
fi
echo "triton deleted"; exit 0
