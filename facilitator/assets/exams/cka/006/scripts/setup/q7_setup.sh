#!/bin/bash
# Setup for Question 7: rollout namespace (source: theplatformlab exercise 06)
kubectl create namespace rollout-ex06 --dry-run=client -o yaml | kubectl apply -f -
exit 0
