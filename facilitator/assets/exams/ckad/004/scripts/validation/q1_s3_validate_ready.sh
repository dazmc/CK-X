#!/bin/bash
for i in $(seq 1 30); do
  R=$(kubectl get deployment postgres-client -n ckad-secret -o jsonpath='{.status.conditions[?(@.type=="Available")].status}' 2>/dev/null)
  if [ "$R" = "True" ]; then echo "Deployment available with replacement Pod"; exit 0; fi
  sleep 2
done
echo "Deployment not available after 60s (condition: ${R:-missing})"; exit 1
