#!/bin/bash
# Setup for Question 5: configmap pre-created as per the question
kubectl create configmap redis-config -n default \
  --from-literal=redis-config.conf='maxmemory 128mb' \
  --dry-run=client -o yaml | kubectl apply -f -
exit 0
