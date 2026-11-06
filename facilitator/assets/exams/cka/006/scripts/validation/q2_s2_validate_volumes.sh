#!/bin/bash
J=$(kubectl get deploy logger -n sidecar-ex02 -o json 2>/dev/null) || { echo "Deployment logger not found"; exit 1; }
echo "$J" | jq -e '.spec.template.spec.volumes[] | select(.name=="log-volume") | select(has("emptyDir"))' >/dev/null || {
  echo "emptyDir volume log-volume missing from the Pod template"
  exit 1
}
APP=$(echo "$J" | jq -r '[.spec.template.spec.containers[] | select(.name=="app") | .volumeMounts[]? | select(.name=="log-volume") | .mountPath] | first // empty')
SIDECAR=$(echo "$J" | jq -r '[.spec.template.spec.initContainers[] | select(.name=="log-agent") | .volumeMounts[]? | select(.name=="log-volume") | .mountPath] | first // empty')
if [ "$APP" != "/var/log/app" ]; then
  echo "app container mounts log-volume at '${APP:-none}', expected /var/log/app"
  exit 1
fi
if [ "$SIDECAR" != "/var/log/app" ]; then
  echo "log-agent mounts log-volume at '${SIDECAR:-none}', expected /var/log/app"
  exit 1
fi
echo "Both containers share emptyDir log-volume at /var/log/app"
exit 0
