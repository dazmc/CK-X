#!/bin/bash
V=$(kubectl get cm payments-config -n prod -o jsonpath='{.data.app\.env}' 2>/dev/null)
if [ -z "$V" ]; then
  echo "ConfigMap payments-config with key app.env not found in prod"
  exit 1
fi
if ! echo "$V" | grep -q "DB_HOST=postgres.prod.svc.cluster.local"; then
  echo "app.env does not contain DB_HOST=postgres.prod.svc.cluster.local"
  exit 1
fi
echo "ConfigMap payments-config has the required app.env content"
exit 0
