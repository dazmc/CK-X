#!/bin/bash
S=$(kubectl get job cleanup-job -n job-ex21 -o jsonpath='{.status.succeeded}' 2>/dev/null)
if [ "${S:-0}" -lt 3 ]; then
  echo "Job succeeded='${S:-none}', expected 3 completions"
  exit 1
fi
echo "Job completed 3/3"
exit 0
