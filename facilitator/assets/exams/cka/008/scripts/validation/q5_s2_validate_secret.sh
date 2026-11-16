#!/bin/bash
J=$(kubectl get secret db-secret -n env-demo -o json 2>/dev/null) || { echo "Secret db-secret not found in env-demo"; exit 1; }
D=$(echo "$J" | jq -r '.data.DB_PASSWORD // "missing"')
if [ "$D" = "missing" ]; then
  echo "db-secret has no DB_PASSWORD key"
  exit 1
fi
V=$(echo "$D" | base64 -d 2>/dev/null)
if [ "$V" != "supersecret" ]; then
  echo "DB_PASSWORD decodes to '$V', expected supersecret"
  exit 1
fi
echo "Secret db-secret has DB_PASSWORD=supersecret"
exit 0
