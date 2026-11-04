#!/bin/bash
for SA in fe frontend; do
  if kubectl get serviceaccount $SA -n omni >/dev/null 2>&1; then
    echo "Unused service account '$SA' still exists"; exit 1
  fi
done
kubectl get serviceaccount default -n omni >/dev/null 2>&1 || { echo "default SA was deleted"; exit 1; }
kubectl get serviceaccount frontend-default -n omni >/dev/null 2>&1 || { echo "frontend-default SA was deleted"; exit 1; }
echo "Unused SAs deleted, default and frontend-default kept"; exit 0
