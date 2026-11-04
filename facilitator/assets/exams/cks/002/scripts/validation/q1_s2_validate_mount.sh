#!/bin/bash
POD=app-xyz
if ! kubectl get pod $POD -n orion >/dev/null 2>&1; then
  echo "Pod $POD not found"; exit 1
fi
SN=$(kubectl get pod $POD -n orion -o jsonpath='{.spec.volumes[?(@.name=="secret-volume")].secret.secretName}')
if [ -z "$SN" ]; then
  SN=$(kubectl get pod $POD -n orion -o jsonpath='{.spec.volumes[0].secret.secretName}')
fi
MP=$(kubectl get pod $POD -n orion -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/mnt/connector/password")].mountPath}')
RO=$(kubectl get pod $POD -n orion -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/mnt/connector/password")].readOnly}')
ENVCOUNT=$(kubectl get pod $POD -n orion -o jsonpath='{.spec.containers[0].env[*].name}' | tr ' ' '\n' | grep -cx 'CONNECTOR_PASSWORD' || true)
[ "$SN" = "a-safe-secret" ] || { echo "No volume mounts secret a-safe-secret (found '${SN:-none}')"; exit 1; }
[ "$MP" = "/mnt/connector/password" ] || { echo "Secret not mounted at /mnt/connector/password (found '${MP:-none}')"; exit 1; }
[ "$RO" = "true" ] || { echo "Mount is not readOnly"; exit 1; }
[ "$ENVCOUNT" -eq 0 ] || { echo "CONNECTOR_PASSWORD is still set as an environment variable"; exit 1; }
echo "Secret mounted read-only at /mnt/connector/password, env var removed"; exit 0
