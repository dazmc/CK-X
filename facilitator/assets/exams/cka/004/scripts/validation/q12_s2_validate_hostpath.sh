#!/bin/bash
PV=pv-analytics
HP=$(kubectl get pv $PV -o jsonpath='{.spec.hostPath.path}' 2>/dev/null)
if [ "$HP" = "/pv/data-analytics" ]; then
  echo "hostPath is /pv/data-analytics"; exit 0
fi
echo "hostPath is '${HP:-none}', expected /pv/data-analytics"; exit 1
