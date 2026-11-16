#!/bin/bash
J=$(kubectl get configmap app-config -n env-demo -o json 2>/dev/null) || { echo "ConfigMap app-config not found in env-demo"; exit 1; }
AE=$(echo "$J" | jq -r '.data.APP_ENV // "missing"')
LL=$(echo "$J" | jq -r '.data.LOG_LEVEL // "missing"')
if [ "$AE" != "production" ]; then
  echo "APP_ENV is '$AE', expected production"
  exit 1
fi
if [ "$LL" != "info" ]; then
  echo "LOG_LEVEL is '$LL', expected info"
  exit 1
fi
echo "ConfigMap app-config has APP_ENV=production and LOG_LEVEL=info"
exit 0
