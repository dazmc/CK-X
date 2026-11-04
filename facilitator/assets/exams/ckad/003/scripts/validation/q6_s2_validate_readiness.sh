#!/bin/bash
RP=$(kubectl get pod nginx1401 -n dev1401 -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.port}' 2>/dev/null)
if [ "$RP" = "80" ]; then
  echo "Readiness probe uses port 80"; exit 0
fi
echo "Readiness probe port is '${RP:-none}', expected 80"; exit 1
