#!/bin/bash
# Validate endpoints are populated and traffic works end to end
ADDRS=$(kubectl get endpoints shop-svc -n repair -o jsonpath='{.subsets[0].addresses[*].ip}' 2>/dev/null)
COUNT=$(echo "$ADDRS" | wc -w)
if [ "$COUNT" -lt 3 ]; then
    echo "❌ Service shop-svc should have 3 endpoint addresses (found: $COUNT)"
    exit 1
fi
kubectl run repair-test-$RANDOM -n repair --rm -i --restart=Never --image=curlimages/curl:8.10.1 -- \
  curl -s -m 10 http://shop-svc.repair.svc.cluster.local/ >/dev/null 2>&1 || {
    echo "❌ Could not reach shop-svc from a test pod"
    exit 1
}
echo "✅ Endpoints populated and traffic flows through shop-svc"
exit 0
