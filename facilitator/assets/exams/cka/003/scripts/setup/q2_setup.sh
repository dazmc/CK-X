#!/bin/bash
# Setup for Question 2: Labeled pods and kubectl output
kubectl create namespace pod-basics --dry-run=client -o yaml | kubectl apply -f -
rm -f /tmp/exam/running-pods.txt
exit 0
