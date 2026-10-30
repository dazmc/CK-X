#!/bin/bash
# Validate ingress uses networking.k8s.io/v1 with required modern fields
API=$(kubectl get ingress legacy-ingress -n api-update -o jsonpath='{.apiVersion}' 2>/dev/null)
if [ "$API" != "networking.k8s.io/v1" ]; then
    echo "❌ Ingress legacy-ingress apiVersion should be networking.k8s.io/v1 (found: '${API:-none}')"
    exit 1
fi
PATHTYPE=$(kubectl get ingress legacy-ingress -n api-update -o jsonpath='{.spec.rules[0].http.paths[0].pathType}' 2>/dev/null)
if [ -z "$PATHTYPE" ]; then
    echo "❌ Ingress is missing the required pathType field (e.g. Prefix)"
    exit 1
fi
PORT=$(kubectl get ingress legacy-ingress -n api-update -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null)
if [ "$PORT" != "80" ]; then
    echo "❌ Ingress backend service port should be 80 (found: '${PORT:-none}')"
    exit 1
fi
echo "✅ Ingress legacy-ingress uses networking.k8s.io/v1 with valid fields"
exit 0
