#!/bin/bash
# Validate service selector matches app=shop and targetPort is 80
SELECTOR=$(kubectl get svc shop-svc -n repair -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$SELECTOR" != "shop" ]; then
    echo "❌ Service shop-svc selector.app should be 'shop' (found: '${SELECTOR:-none}')"
    exit 1
fi
TP=$(kubectl get svc shop-svc -n repair -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
if [ "$TP" != "80" ]; then
    echo "❌ Service shop-svc targetPort should be 80 (found: '$TP')"
    exit 1
fi
echo "✅ Service selector and targetPort are correct"
exit 0
