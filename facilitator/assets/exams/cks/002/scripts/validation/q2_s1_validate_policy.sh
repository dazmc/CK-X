#!/bin/bash
NP=allow-redis-access
if ! kubectl get networkpolicy $NP -n prod-x12cs >/dev/null 2>&1; then
  echo "NetworkPolicy $NP not found in prod-x12cs"; exit 1
fi
SEL=$(kubectl get networkpolicy $NP -n prod-x12cs -o jsonpath='{.spec.podSelector.matchLabels.run}')
PT=$(kubectl get networkpolicy $NP -n prod-x12cs -o jsonpath='{.spec.policyTypes[*]}')
[ "$SEL" = "redis-backend" ] || { echo "podSelector run='${SEL:-none}', expected redis-backend"; exit 1; }
echo "$PT" | grep -qw "Ingress" || { echo "policyTypes are '$PT', expected to include Ingress"; exit 1; }
echo "Policy selects redis-backend with policy type Ingress"; exit 0
