#!/bin/bash
# Validate completions=4, parallelism=2, backoffLimit=6, restartPolicy=Never
OK=1
COMPLETIONS=$(kubectl get job batch-worker -n batch-jobs -o jsonpath='{.spec.completions}' 2>/dev/null)
[ "$COMPLETIONS" != "4" ] && { echo "❌ completions should be 4 (found: $COMPLETIONS)"; OK=0; }
PARALLELISM=$(kubectl get job batch-worker -n batch-jobs -o jsonpath='{.spec.parallelism}' 2>/dev/null)
[ "$PARALLELISM" != "2" ] && { echo "❌ parallelism should be 2 (found: $PARALLELISM)"; OK=0; }
BACKOFF=$(kubectl get job batch-worker -n batch-jobs -o jsonpath='{.spec.backoffLimit}' 2>/dev/null)
[ "$BACKOFF" != "6" ] && { echo "❌ backoffLimit should be 6 (found: $BACKOFF)"; OK=0; }
RESTART=$(kubectl get job batch-worker -n batch-jobs -o jsonpath='{.spec.template.spec.restartPolicy}' 2>/dev/null)
[ "$RESTART" != "Never" ] && { echo "❌ restartPolicy should be Never (found: $RESTART)"; OK=0; }
TTL=$(kubectl get job batch-worker -n batch-jobs -o jsonpath='{.spec.ttlSecondsAfterFinished}' 2>/dev/null)
[ "$TTL" != "120" ] && { echo "❌ ttlSecondsAfterFinished should be 120 (found: ${TTL:-none})"; OK=0; }
[ $OK -eq 0 ] && exit 1
echo "✅ Job batch-worker configuration is correct"
exit 0
