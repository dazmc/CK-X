#!/bin/bash
J=$(kubectl get deploy app -n wffc-ex25 -o json 2>/dev/null) || { echo "Deployment app not found"; exit 1; }
VOL=$(echo "$J" | jq -r '[.spec.template.spec.volumes[]? | select(.persistentVolumeClaim.claimName=="local-pvc") | .name] | first // empty')
if [ -z "$VOL" ]; then
  echo "Deployment app does not mount PVC local-pvc"
  exit 1
fi
MP=$(echo "$J" | jq -r --arg v "$VOL" '[.spec.template.spec.containers[] | .volumeMounts[]? | select(.name==$v) | .mountPath] | first // empty')
if [ "$MP" != "/data" ]; then
  echo "local-pvc is mounted at '${MP:-none}', expected /data"
  exit 1
fi
R=$(echo "$J" | jq -r '.status.readyReplicas // 0')
if [ "$R" -lt 1 ]; then
  echo "Deployment app is not Ready (readyReplicas=$R)"
  exit 1
fi
echo "Deployment app mounts local-pvc at /data and is Ready"
exit 0
