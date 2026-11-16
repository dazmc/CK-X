#!/bin/bash
J=$(kubectl get netpol deny-all -n secure -o json 2>/dev/null) || { echo "NetworkPolicy deny-all not found in secure"; exit 1; }
if ! echo "$J" | jq -e '.spec.podSelector == {}' >/dev/null; then
  PS=$(echo "$J" | jq -c '.spec.podSelector')
  echo "podSelector is $PS, expected {} - it must select ALL pods in the namespace"
  exit 1
fi
echo "deny-all exists with podSelector {} (all pods)"
exit 0
