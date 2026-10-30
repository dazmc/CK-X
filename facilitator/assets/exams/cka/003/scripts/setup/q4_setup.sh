#!/bin/bash
# Setup for Question 4: Deployment + NodePort service
kubectl create namespace nodeport-lab --dry-run=client -o yaml | kubectl apply -f -
exit 0
