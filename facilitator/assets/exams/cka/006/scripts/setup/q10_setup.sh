#!/bin/bash
# Setup for Question 10: job namespace (source: theplatformlab exercise 21 + mock Q15)
kubectl create namespace job-ex21 --dry-run=client -o yaml | kubectl apply -f -
exit 0
