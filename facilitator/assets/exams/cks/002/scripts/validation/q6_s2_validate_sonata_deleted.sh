#!/bin/bash
if kubectl get pod sonata -n alpha >/dev/null 2>&1; then
  echo "Mutable pod sonata (readOnlyRootFilesystem: false) still exists"; exit 1
fi
echo "sonata deleted"; exit 0
