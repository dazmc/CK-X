#!/bin/bash
CJ=dice
if ! kubectl get cronjob $CJ -n default >/dev/null 2>&1; then
  echo "CronJob $CJ not found"; exit 1
fi
SCH=$(kubectl get cronjob $CJ -n default -o jsonpath='{.spec.schedule}')
IMG=$(kubectl get cronjob $CJ -n default -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}')
[ "$SCH" = "*/1 * * * *" ] || { echo "Schedule is '$SCH', expected */1 * * * *"; exit 1; }
[ "$IMG" = "kodekloud/throw-dice" ] || { echo "Image is '$IMG', expected kodekloud/throw-dice"; exit 1; }
echo "CronJob dice runs every minute with the correct image"; exit 0
