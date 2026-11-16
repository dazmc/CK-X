#!/bin/bash
# Setup for Question 2: sa-token namespace (ServiceAccount + pod by candidate)
# (source: techiescamp Q4)
kubectl create namespace sa-token --dry-run=client -o yaml | kubectl apply -f -
exit 0
