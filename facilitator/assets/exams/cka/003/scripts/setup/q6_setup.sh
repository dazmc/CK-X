#!/bin/bash
# Setup for Question 6: Batch Job
kubectl create namespace batch-jobs --dry-run=client -o yaml | kubectl apply -f -
exit 0
