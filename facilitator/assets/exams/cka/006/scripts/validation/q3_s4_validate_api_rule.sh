#!/bin/bash
if ! kubectl get ingress web-ingress -n ingress-ex19 -o json 2>/dev/null | jq -e '
    .spec.rules[] | select(.host=="api.example.com") | .http.paths[] |
    select(.path=="/api") | select(.pathType=="Prefix") |
    select(.backend.service.name=="api-service") | select(.backend.service.port.number==8080)' >/dev/null; then
  echo "api.example.com must route path /api (Prefix) to api-service:8080"
  exit 1
fi
echo "api.example.com /api -> api-service:8080"
exit 0
