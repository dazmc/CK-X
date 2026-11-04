#!/bin/bash
POD=apps-cluster-dash
MP=$(kubectl get pod $POD -n gamma -o jsonpath='{.spec.containers[0].volumeMounts[*].mountPath}')
if echo "$MP" | grep -q "/var/run/secrets/kubernetes.io/serviceaccount"; then
  echo "Service account token is still volume-mounted: $MP"; exit 1
fi
VOLS=$(kubectl get pod $POD -n gamma -o jsonpath='{.spec.volumes[*].name}')
for V in $VOLS; do
  S=$(kubectl get pod $POD -n gamma -o jsonpath="{.spec.volumes[?(@.name==\"$V\")].secret.secretName}")
  case "$S" in
    *token*|*service-account*)
      echo "Token secret volume '$V' ($S) still present"; exit 1;;
  esac
done
SA=$(kubectl get pod $POD -n gamma -o jsonpath='{.spec.serviceAccountName}')
[ "$SA" = "cluster-view" ] || { echo "serviceAccountName is '${SA:-none}', expected cluster-view"; exit 1; }
echo "No token volume mounted, still using cluster-view"; exit 0
