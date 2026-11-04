#!/bin/bash
if ! kubectl get pod solaris -n alpha >/dev/null 2>&1; then
  echo "Immutable pod solaris was deleted"; exit 1
fi
RO=$(kubectl get pod solaris -n alpha -o jsonpath='{.spec.containers[0].securityContext.readOnlyRootFilesystem}')
[ "$RO" = "true" ] || { echo "solaris readOnlyRootFilesystem is '${RO:-unset}', expected true"; exit 1; }
echo "Immutable pod solaris still exists"; exit 0
