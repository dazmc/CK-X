#!/bin/bash
for i in $(seq 1 30); do
  L=$(kubectl logs deployment/inspector -n ckad-rbac 2>/dev/null)
  if [ -n "$L" ] && ! echo "$L" | grep -q "Forbidden"; then
    if echo "$L" | grep -q "inspector"; then
      echo "New Pod logs list Pods with no Forbidden error"; exit 0
    fi
  fi
  sleep 2
done
echo "Logs still show Forbidden or no successful Pod listing after 60s"; exit 1
