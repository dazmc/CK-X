#!/bin/bash
if [ ! -s /tmp/exam/pending_pod_uid.txt ]; then
  echo "recorded pod identity file /tmp/exam/pending_pod_uid.txt missing - cannot verify the pod was not recreated"
  exit 1
fi
NOW=$(kubectl get pod pending-pod -n pending-lab -o jsonpath='{.metadata.uid}' 2>/dev/null)
WAS=$(cat /tmp/exam/pending_pod_uid.txt)
if [ -z "$NOW" ]; then
  echo "pod pending-pod no longer exists - it must not be deleted or recreated"
  exit 1
fi
if [ "$NOW" != "$WAS" ]; then
  echo "pod identity changed (uid $WAS -> $NOW) - do not delete or edit the pod, label the node instead"
  exit 1
fi
echo "Pod identity preserved (uid unchanged)"
exit 0
