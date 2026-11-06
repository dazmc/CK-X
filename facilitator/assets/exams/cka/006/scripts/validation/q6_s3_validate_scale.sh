#!/bin/bash
SPEC=$(kubectl get deploy drain-demo -n drain-ex08 -o jsonpath='{.spec.replicas}' 2>/dev/null)
READY=$(kubectl get deploy drain-demo -n drain-ex08 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "$SPEC" != "4" ]; then
  echo "drain-demo spec.replicas is '${SPEC:-none}', expected 4"
  exit 1
fi
if [ "${READY:-0}" -ne 4 ]; then
  echo "drain-demo has ${READY:-0} ready replicas, expected 4"
  exit 1
fi
echo "drain-demo runs 4 ready replicas"
exit 0
