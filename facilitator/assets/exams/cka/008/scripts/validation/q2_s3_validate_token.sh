#!/bin/bash
FILES=$(kubectl exec -n sa-token sa-pod -- ls /var/run/secrets/kubernetes.io/serviceaccount/ 2>/dev/null)
if ! echo "$FILES" | grep -q "^token$"; then
  echo "/var/run/secrets/kubernetes.io/serviceaccount/ does not contain a token file (got: ${FILES:-nothing})"
  exit 1
fi
SEG=$(kubectl exec -n sa-token sa-pod -- sh -c 'cut -d. -f2 /var/run/secrets/kubernetes.io/serviceaccount/token 2>/dev/null' 2>/dev/null)
if [ -z "$SEG" ]; then
  echo "could not read the mounted token"
  exit 1
fi
PAYLOAD=$(echo "$SEG" | tr '_-' '/+' | base64 -d 2>/dev/null)
if ! echo "$PAYLOAD" | grep -q '"sub":"system:serviceaccount:sa-token:app-sa"'; then
  echo "mounted token subject does not reference sa-token:app-sa (payload: $(echo "$PAYLOAD" | head -c 200))"
  exit 1
fi
echo "Service account token mounted and issued for app-sa"
exit 0
