#!/bin/bash
R=$(kubectl get deploy logger -n sidecar-ex02 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "${R:-0}" -lt 1 ]; then
  echo "Deployment logger has ${R:-0} ready replicas, expected at least 1"
  exit 1
fi
RUN=$(kubectl get pods -n sidecar-ex02 -l app=logger -o jsonpath='{.items[0].status.initContainerStatuses[?(@.name=="log-agent")].state.running}' 2>/dev/null)
if [ -z "$RUN" ]; then
  echo "Sidecar container log-agent is not running"
  exit 1
fi
echo "Pod is Ready and the log-agent sidecar is running"
exit 0
