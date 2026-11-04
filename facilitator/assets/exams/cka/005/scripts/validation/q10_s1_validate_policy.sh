#!/bin/bash
NP=ingress-to-nptest
if ! kubectl get networkpolicy $NP -n default >/dev/null 2>&1; then
  echo "NetworkPolicy $NP not found"; exit 1
fi
SEL=$(kubectl get networkpolicy $NP -n default -o jsonpath='{.spec.podSelector.matchLabels.run}')
PT=$(kubectl get networkpolicy $NP -n default -o jsonpath='{.spec.policyTypes[*]}')
[ "$SEL" = "np-test-1" ] || { echo "podSelector run='${SEL:-none}', expected np-test-1"; exit 1; }
echo "$PT" | grep -qw "Ingress" || { echo "policyTypes are '$PT', expected to include Ingress"; exit 1; }
echo "Policy selects np-test-1 with policy type Ingress"; exit 0
