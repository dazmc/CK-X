#!/bin/bash
# Validate cronjob uses batch/v1 and is scheduled
API=$(kubectl get cronjob legacy-cron -n api-update -o jsonpath='{.apiVersion}' 2>/dev/null)
if [ "$API" != "batch/v1" ]; then
    echo "❌ CronJob legacy-cron apiVersion should be batch/v1 (found: '${API:-none}')"
    exit 1
fi
SCHEDULE=$(kubectl get cronjob legacy-cron -n api-update -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [ "$SCHEDULE" != "*/5 * * * *" ]; then
    echo "❌ CronJob schedule should be '*/5 * * * *' (found: '${SCHEDULE:-none}')"
    exit 1
fi
echo "✅ CronJob legacy-cron uses batch/v1 with correct schedule"
exit 0
