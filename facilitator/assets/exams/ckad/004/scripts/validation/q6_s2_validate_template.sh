#!/bin/bash
CJ=half-hour-report
if ! kubectl get cronjob $CJ -n ckad-cron >/dev/null 2>&1; then
  echo "CronJob $CJ not found in ckad-cron"; exit 1
fi
NAME=$(kubectl get cronjob $CJ -n ckad-cron -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].name}')
IMG=$(kubectl get cronjob $CJ -n ckad-cron -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}')
RP=$(kubectl get cronjob $CJ -n ckad-cron -o jsonpath='{.spec.jobTemplate.spec.template.spec.restartPolicy}')
CMD=$(kubectl get cronjob $CJ -n ckad-cron -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].command[*]}')
[ "$NAME" = "sp" ] || { echo "container name is '${NAME:-none}', expected sp"; exit 1; }
[ "$IMG" = "busybox:1.28" ] || { echo "image is '${IMG:-none}', expected busybox:1.28"; exit 1; }
[ "$RP" = "Never" ] || { echo "restartPolicy is '${RP:-none}', expected Never"; exit 1; }
echo "$CMD" | grep -q "/bin/sh" || { echo "command missing /bin/sh: '$CMD'"; exit 1; }
echo "$CMD" | grep -q "Hello from the Kubernetes cluster" || { echo "command missing the echo text: '$CMD'"; exit 1; }
echo "Job template is correct"; exit 0
