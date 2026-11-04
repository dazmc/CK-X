#!/bin/bash
for i in $(seq 1 30); do
  R=$(kubectl get pod nginx1401 -n dev1401 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
  if [ "$R" = "True" ]; then echo "Pod nginx1401 is Ready"; exit 0; fi
  sleep 2
done
echo "Pod Ready condition is '${R:-missing}', expected True after 60s"; exit 1
