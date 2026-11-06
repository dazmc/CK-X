#!/bin/bash
if ! kubectl get ingress web-ingress -n ingress-ex19 -o json 2>/dev/null | jq -e '
    .spec.tls[]? | select(.secretName=="api-tls-cert") | select(.hosts | index("api.example.com"))' >/dev/null; then
  echo "TLS section must use secret api-tls-cert for host api.example.com"
  exit 1
fi
echo "TLS configured with api-tls-cert for api.example.com"
exit 0
