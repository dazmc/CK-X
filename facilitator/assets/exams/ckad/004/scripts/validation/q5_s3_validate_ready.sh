#!/bin/bash
for i in $(seq 1 30); do
  R=$(kubectl get deployment api -n ckad-container -o jsonpath='{.status.conditions[?(@.type=="Available")].status}' 2>/dev/null)
  if [ "$R" = "True" ]; then echo "Rollout complete, Pod is Ready"; exit 0; fi
  sleep 2
done
echo "Deployment not available after 60s (condition: ${R:-missing})"; exit 1
