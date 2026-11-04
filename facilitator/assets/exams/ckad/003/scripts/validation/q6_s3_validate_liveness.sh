#!/bin/bash
LP=$(kubectl get pod nginx1401 -n dev1401 -o jsonpath='{.spec.containers[0].livenessProbe.exec.command[*]}' 2>/dev/null)
IDS=$(kubectl get pod nginx1401 -n dev1401 -o jsonpath='{.spec.containers[0].livenessProbe.initialDelaySeconds}' 2>/dev/null)
PS=$(kubectl get pod nginx1401 -n dev1401 -o jsonpath='{.spec.containers[0].livenessProbe.periodSeconds}' 2>/dev/null)
if [ -z "$LP" ]; then echo "No liveness probe found"; exit 1; fi
echo "$LP" | grep -q "ls" || { echo "Liveness command missing ls: '$LP'"; exit 1; }
echo "$LP" | grep -q "/var/www/html/file_check" || { echo "Liveness command missing /var/www/html/file_check: '$LP'"; exit 1; }
[ "$IDS" = "10" ] || { echo "initialDelaySeconds is '${IDS:-none}', expected 10"; exit 1; }
[ "$PS" = "60" ] || { echo "periodSeconds is '${PS:-none}', expected 60"; exit 1; }
echo "Liveness probe is correct"; exit 0
