#!/bin/bash
# Setup for Question 2: native sidecar namespace (source: theplatformlab exercise 02)
kubectl create namespace sidecar-ex02 --dry-run=client -o yaml | kubectl apply -f -
exit 0
