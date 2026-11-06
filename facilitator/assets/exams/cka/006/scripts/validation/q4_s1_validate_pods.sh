#!/bin/bash
SPEC=$(kubectl get deploy web -n resource-tuning -o jsonpath='{.spec.replicas}' 2>/dev/null)
READY=$(kubectl get deploy web -n resource-tuning -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "$SPEC" != "3" ]; then
  echo "Deployment web has spec.replicas='${SPEC:-none}', expected 3"
  exit 1
fi
if [ "${READY:-0}" -ne 3 ]; then
  echo "Deployment web has ${READY:-0} ready replicas, expected 3"
  exit 1
fi
echo "Deployment web runs 3 ready replicas"
exit 0
