#!/bin/bash
# Validate job batch-worker exists
kubectl get job batch-worker -n batch-jobs &>/dev/null || {
    echo "❌ Job batch-worker not found in namespace batch-jobs"
    exit 1
}
echo "✅ Job batch-worker exists"
exit 0
