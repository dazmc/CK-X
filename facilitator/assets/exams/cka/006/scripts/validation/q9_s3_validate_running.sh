#!/bin/bash
R=$(kubectl get deploy payments-api -n prod -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "${R:-0}" -lt 1 ]; then
  echo "payments-api has ${R:-0} ready replicas - the pod is still CrashLoopBackOff"
  exit 1
fi
if ! kubectl exec -n prod deploy/payments-api -- test -f /etc/app/app.env 2>/dev/null; then
  echo "/etc/app/app.env does not exist inside the container"
  exit 1
fi
echo "Pod is Ready and /etc/app/app.env exists"
exit 0
