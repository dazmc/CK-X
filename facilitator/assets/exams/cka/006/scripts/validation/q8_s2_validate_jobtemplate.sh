#!/bin/bash
J=$(kubectl get cronjob db-cleanup -n cron-ex21 -o json 2>/dev/null) || { echo "CronJob db-cleanup not found"; exit 1; }
BL=$(echo "$J" | jq -r '.spec.jobTemplate.spec.backoffLimit // "missing"')
IMG=$(echo "$J" | jq -r '.spec.jobTemplate.spec.template.spec.containers[0].image // "missing"')
RP=$(echo "$J" | jq -r '.spec.jobTemplate.spec.template.spec.restartPolicy // "missing"')
CMD=$(echo "$J" | jq -r '[.spec.jobTemplate.spec.template.spec.containers[0] | ((.command // []) + (.args // []))[]] | join(" ")')
if [ "$BL" != "2" ]; then
  echo "backoffLimit is '$BL', expected 2"
  exit 1
fi
if [ "$IMG" != "busybox:1.37" ]; then
  echo "image is '$IMG', expected busybox:1.37"
  exit 1
fi
if [ "$RP" != "Never" ]; then
  echo "job restartPolicy is '$RP', expected Never"
  exit 1
fi
if ! echo "$CMD" | grep -q "echo cleanup"; then
  echo "command is '$CMD', expected to contain 'echo cleanup'"
  exit 1
fi
echo "Job template correct (busybox:1.37, backoffLimit 2, restartPolicy Never, cleanup command)"
exit 0
