#!/bin/bash
J=$(kubectl get netpol deny-all -n secure -o json 2>/dev/null) || { echo "NetworkPolicy deny-all not found in secure"; exit 1; }
ING=$(echo "$J" | jq -r '[.spec.policyTypes[]? | select(.=="Ingress")] | length')
EGR=$(echo "$J" | jq -r '[.spec.policyTypes[]? | select(.=="Egress")] | length')
if [ "$ING" -lt 1 ]; then
  echo "policyTypes must include Ingress"
  exit 1
fi
if [ "$EGR" -lt 1 ]; then
  echo "policyTypes must include Egress"
  exit 1
fi
echo "policyTypes covers both Ingress and Egress"
exit 0
