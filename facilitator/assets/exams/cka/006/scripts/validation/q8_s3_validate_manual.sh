#!/bin/bash
S=$(kubectl get job db-cleanup-manual -n cron-ex21 -o jsonpath='{.status.succeeded}' 2>/dev/null)
if [ "${S:-0}" -lt 1 ]; then
  echo "Job db-cleanup-manual succeeded='${S:-none}', expected >= 1 (create it with: kubectl create job db-cleanup-manual --from=cronjob/db-cleanup)"
  exit 1
fi
echo "db-cleanup-manual completed successfully"
exit 0
