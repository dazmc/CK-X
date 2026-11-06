#!/bin/bash
S=$(kubectl get cronjob db-cleanup -n cron-ex21 -o jsonpath='{.spec.schedule}' 2>/dev/null)
C=$(kubectl get cronjob db-cleanup -n cron-ex21 -o jsonpath='{.spec.concurrencyPolicy}' 2>/dev/null)
if [ "$S" != "*/5 * * * *" ]; then
  echo "schedule is '${S:-none}', expected */5 * * * *"
  exit 1
fi
if [ "$C" != "Forbid" ]; then
  echo "concurrencyPolicy is '${C:-none}', expected Forbid"
  exit 1
fi
echo "CronJob schedule and concurrencyPolicy are correct"
exit 0
