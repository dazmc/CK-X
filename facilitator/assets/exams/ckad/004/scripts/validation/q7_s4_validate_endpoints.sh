#!/bin/bash
for i in $(seq 1 30); do
  READY=$(kubectl get endpointslice -n ckad-canary -l kubernetes.io/service-name=storefront \
    -o jsonpath='{range .items[*]}{range .endpoints[*]}{.conditions.ready}{"\n"}{end}{end}' 2>/dev/null \
    | grep -c '^true$' || true)
  if [ "$READY" -eq 10 ]; then
    echo "Service storefront has 10 ready endpoints"; exit 0
  fi
  sleep 2
done
echo "Service storefront has $READY ready endpoints, expected 10 after 60s"; exit 1
