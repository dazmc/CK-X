#!/bin/bash
# Validate the service selector matches the pod label app=frontend
SELECTOR=$(kubectl get svc frontend-svc -n svc-endpoints -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$SELECTOR" != "frontend" ]; then
    echo "❌ Service frontend-svc selector.app should be 'frontend' (found: '${SELECTOR:-none}')"
    exit 1
fi
echo "✅ Service frontend-svc selector matches app=frontend"
exit 0
