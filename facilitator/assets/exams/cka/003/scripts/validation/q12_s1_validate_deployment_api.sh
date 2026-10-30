#!/bin/bash
# Validate deployment uses apps/v1 and exists
API=$(kubectl get deployment legacy-app -n api-update -o jsonpath='{.apiVersion}' 2>/dev/null)
if [ "$API" != "apps/v1" ]; then
    echo "❌ Deployment legacy-app apiVersion should be apps/v1 (found: '${API:-none}')"
    exit 1
fi
echo "✅ Deployment legacy-app uses apps/v1"
exit 0
