#!/bin/bash
for i in $(seq 1 30); do
  READY=$(kubectl get endpointslice -n ckad-ingress-fix -l kubernetes.io/service-name=catalog \
    -o jsonpath='{range .items[*]}{range .endpoints[*]}{.conditions.ready}{"\n"}{end}{end}' 2>/dev/null \
    | grep -c '^true$' || true)
  if [ "$READY" -ge 1 ]; then
    echo "Service catalog has $READY ready endpoint(s)"; exit 0
  fi
  sleep 2
done
echo "Service catalog has no ready endpoints after 60s"; exit 1
