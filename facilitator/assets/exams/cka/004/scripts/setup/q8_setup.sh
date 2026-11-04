#!/bin/bash
# Setup for Question 8: namespace finance is pre-created (not part of the task)
kubectl create namespace finance --dry-run=client -o yaml | kubectl apply -f -
exit 0
