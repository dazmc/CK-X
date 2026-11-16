#!/bin/bash
# Setup for Question 6: dynamic-storage namespace (default-SC PVC + pod by candidate)
# (source: techiescamp Q15+Q16 merged)
kubectl create namespace dynamic-storage --dry-run=client -o yaml | kubectl apply -f -
exit 0
