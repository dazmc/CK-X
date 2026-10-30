#!/bin/bash
# Validate job batch-worker completed successfully
SUCCEEDED=$(kubectl get job batch-worker -n batch-jobs -o jsonpath='{.status.succeeded}' 2>/dev/null)
if [ "${SUCCEEDED:-0}" -lt 4 ]; then
    echo "❌ Job batch-worker has not completed 4 pods (succeeded: ${SUCCEEDED:-0})"
    kubectl get job batch-worker -n batch-jobs
    exit 1
fi
echo "✅ Job batch-worker completed successfully with 4 pods"
exit 0
