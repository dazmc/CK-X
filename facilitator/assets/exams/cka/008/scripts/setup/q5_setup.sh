#!/bin/bash
# Setup for Question 5: env-demo namespace (ConfigMap/Secret/pod by candidate)
# (source: techiescamp Q8)
kubectl create namespace env-demo --dry-run=client -o yaml | kubectl apply -f -
exit 0
