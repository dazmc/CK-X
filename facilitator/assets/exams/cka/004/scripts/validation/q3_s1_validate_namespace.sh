#!/bin/bash
if kubectl get namespace apx-x9984574 >/dev/null 2>&1; then
  echo "Namespace apx-x9984574 exists"; exit 0
fi
echo "Namespace apx-x9984574 not found"; exit 1
