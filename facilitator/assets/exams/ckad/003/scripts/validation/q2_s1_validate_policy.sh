#!/bin/bash
NP=allow-webapp-color
if ! kubectl get networkpolicy $NP -n default >/dev/null 2>&1; then
  echo "NetworkPolicy $NP not found"; exit 1
fi
SEL=$(kubectl get networkpolicy $NP -n default -o jsonpath='{.spec.podSelector.matchLabels.run}')
PT=$(kubectl get networkpolicy $NP -n default -o jsonpath='{.spec.policyTypes[*]}')
[ "$SEL" = "secure-pod" ] || { echo "podSelector run='${SEL:-none}', expected secure-pod"; exit 1; }
echo "$PT" | grep -qw "Ingress" || { echo "policyTypes are '$PT', expected to include Ingress"; exit 1; }
echo "Policy selects secure-pod with policy type Ingress"; exit 0
