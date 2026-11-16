#!/bin/bash
J=$(kubectl get netpol deny-all -n secure -o json 2>/dev/null) || { echo "NetworkPolicy deny-all not found in secure"; exit 1; }
NI=$(echo "$J" | jq -r '[.spec.ingress[]?] | length')
NE=$(echo "$J" | jq -r '[.spec.egress[]?] | length')
if [ "$NI" -gt 0 ]; then
  echo "deny-all defines $NI ingress rule(s) - it must allow nothing (remove them)"
  exit 1
fi
if [ "$NE" -gt 0 ]; then
  echo "deny-all defines $NE egress rule(s) - it must allow nothing (remove them)"
  exit 1
fi
echo "No ingress or egress allow rules defined"
exit 0
