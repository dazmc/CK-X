#!/bin/bash
CJ=half-hour-report
if ! kubectl get cronjob $CJ -n ckad-cron >/dev/null 2>&1; then
  echo "CronJob $CJ not found in ckad-cron"; exit 1
fi
S=$(kubectl get cronjob $CJ -n ckad-cron -o jsonpath='{.spec.schedule}')
[ "$S" = "*/30 * * * *" ] || { echo "schedule is '$S', expected */30 * * * *"; exit 1; }
echo "Schedule is */30 * * * *"; exit 0
