#!/bin/bash
J=$(kubectl get pod config-pod -n env-demo -o json 2>/dev/null) || { echo "Pod config-pod not found in env-demo"; exit 1; }
if ! echo "$J" | jq -e '([.spec.containers[] | select(.name=="config-pod")] | length) == 1' >/dev/null; then
  echo "pod must have a container named config-pod"
  exit 1
fi
if ! echo "$J" | jq -e '([.spec.containers[].envFrom[]? | select(.configMapRef.name=="app-config")] | length) >= 1' >/dev/null; then
  echo "container must import all keys of app-config via envFrom (configMapRef)"
  exit 1
fi
if ! echo "$J" | jq -e '([.spec.containers[].env[]? | select(.name=="DB_PASSWORD" and .valueFrom.secretKeyRef.name=="db-secret" and .valueFrom.secretKeyRef.key=="DB_PASSWORD")] | length) == 1' >/dev/null; then
  echo "container must define env DB_PASSWORD from secretKeyRef db-secret key DB_PASSWORD (a single env entry, not envFrom on the secret)"
  exit 1
fi
echo "envFrom app-config and env/secretKeyRef DB_PASSWORD wired correctly"
exit 0
