#!/bin/bash
CJ=half-hour-report
AD=$(kubectl get cronjob $CJ -n ckad-cron -o jsonpath='{.spec.jobTemplate.spec.activeDeadlineSeconds}' 2>/dev/null)
SJ=$(kubectl get cronjob $CJ -n ckad-cron -o jsonpath='{.spec.successfulJobsHistoryLimit}' 2>/dev/null)
FJ=$(kubectl get cronjob $CJ -n ckad-cron -o jsonpath='{.spec.failedJobsHistoryLimit}' 2>/dev/null)
[ "$AD" = "3" ] || { echo "activeDeadlineSeconds is '${AD:-none}', expected 3"; exit 1; }
[ "$SJ" = "3" ] || { echo "successfulJobsHistoryLimit is '${SJ:-none}', expected 3"; exit 1; }
[ "$FJ" = "1" ] || { echo "failedJobsHistoryLimit is '${FJ:-none}', expected 1"; exit 1; }
echo "Deadline and history limits are correct"; exit 0
