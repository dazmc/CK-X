#!/bin/bash
# Setup for Question 4: init-shared namespace (init-container pod by candidate)
# (source: techiescamp Q13)
kubectl create namespace init-shared --dry-run=client -o yaml | kubectl apply -f -
exit 0
