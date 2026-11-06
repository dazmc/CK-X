#!/bin/bash
if kubectl get job manual-test -n ckad-cron >/dev/null 2>&1; then
  echo "Job manual-test exists"; exit 0
fi
echo "Job manual-test not found in ckad-cron"; exit 1
