#!/bin/bash
PH=$(kubectl get pod config-pod -n env-demo -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$PH" != "Running" ]; then
  echo "pod phase is '${PH:-none}', expected Running"
  exit 1
fi
OUT=$(kubectl exec -n env-demo config-pod -- env 2>/dev/null)
if ! echo "$OUT" | grep -q "^APP_ENV=production$"; then
  echo "APP_ENV=production not visible in the container environment"
  exit 1
fi
if ! echo "$OUT" | grep -q "^LOG_LEVEL=info$"; then
  echo "LOG_LEVEL=info not visible in the container environment"
  exit 1
fi
if ! echo "$OUT" | grep -q "^DB_PASSWORD=supersecret$"; then
  echo "DB_PASSWORD=supersecret not visible in the container environment"
  exit 1
fi
echo "All three values are present in the container environment"
exit 0
