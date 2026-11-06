#!/bin/bash
if ! kubectl get ingress web-ingress -n ingress-ex19 -o json 2>/dev/null | jq -e '
    .spec.rules[] | select(.host=="web.example.com") | .http.paths[] |
    select(.path=="/") | select(.pathType=="Prefix") |
    select(.backend.service.name=="web-service") | select(.backend.service.port.number==80)' >/dev/null; then
  echo "web.example.com must route path / (Prefix) to web-service:80"
  exit 1
fi
echo "web.example.com / -> web-service:80"
exit 0
