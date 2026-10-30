#!/bin/bash
# Validate endpoints are populated
ADDRS=$(kubectl get endpoints frontend-svc -n svc-endpoints -o jsonpath='{.subsets[0].addresses[*].ip}' 2>/dev/null)
COUNT=$(echo "$ADDRS" | wc -w)
if [ "$COUNT" -lt 2 ]; then
    echo "❌ Service frontend-svc should have 2 endpoint addresses (found: ${COUNT})"
    exit 1
fi
echo "✅ Service frontend-svc has $COUNT endpoint addresses"
exit 0
