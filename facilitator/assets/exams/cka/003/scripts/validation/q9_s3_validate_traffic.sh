#!/bin/bash
# Validate real traffic flows through the service using a test pod
kubectl run svc-test-$RANDOM -n svc-endpoints --rm -i --restart=Never --image=curlimages/curl:8.10.1 -- \
  curl -s -m 10 http://frontend-svc.svc-endpoints.svc.cluster.local/ >/dev/null 2>&1 || {
    echo "❌ Could not reach frontend-svc from a test pod"
    exit 1
}
echo "✅ Traffic flows through frontend-svc"
exit 0
