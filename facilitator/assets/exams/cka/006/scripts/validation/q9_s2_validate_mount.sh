#!/bin/bash
J=$(kubectl get deploy payments-api -n prod -o json 2>/dev/null) || { echo "Deployment payments-api not found"; exit 1; }
VOL=$(echo "$J" | jq -r '[.spec.template.spec.volumes[]? | select(.configMap.name=="payments-config") | .name] | first // empty')
if [ -z "$VOL" ]; then
  echo "Deployment does not mount ConfigMap payments-config as a volume"
  exit 1
fi
MP=$(echo "$J" | jq -r --arg v "$VOL" '[.spec.template.spec.containers[] | .volumeMounts[]? | select(.name==$v) | .mountPath] | first // empty')
if [ "$MP" != "/etc/app" ]; then
  echo "ConfigMap is mounted at '${MP:-none}', expected /etc/app"
  exit 1
fi
echo "payments-config is mounted at /etc/app"
exit 0
