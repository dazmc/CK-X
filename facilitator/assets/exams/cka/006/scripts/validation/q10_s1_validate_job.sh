#!/bin/bash
C=$(kubectl get job cleanup-job -n job-ex21 -o jsonpath='{.spec.completions}' 2>/dev/null)
P=$(kubectl get job cleanup-job -n job-ex21 -o jsonpath='{.spec.parallelism}' 2>/dev/null)
R=$(kubectl get job cleanup-job -n job-ex21 -o jsonpath='{.spec.template.spec.restartPolicy}' 2>/dev/null)
if [ "$C" != "3" ]; then
  echo "completions is '${C:-none}', expected 3"
  exit 1
fi
if [ "$P" != "1" ]; then
  echo "parallelism is '${P:-none}', expected 1"
  exit 1
fi
if [ "$R" != "Never" ]; then
  echo "restartPolicy is '${R:-none}', expected Never"
  exit 1
fi
echo "Job configured: completions 3, parallelism 1, restartPolicy Never"
exit 0
