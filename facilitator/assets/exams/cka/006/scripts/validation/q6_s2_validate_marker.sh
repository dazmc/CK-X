#!/bin/bash
PODS=$(kubectl get pods -n drain-ex08 -l job-name=drain-marker -o name 2>/dev/null)
if [ -n "$PODS" ]; then
  echo "drain-marker pods still exist ($PODS) - the node was not drained (use kubectl drain with --ignore-daemonsets and --delete-emptydir-data)"
  exit 1
fi
echo "drain-marker pods were evicted"
exit 0
