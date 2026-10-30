#!/bin/bash
# Setup for Question 14: Topology spread constraints
kubectl create namespace spread --dry-run=client -o yaml | kubectl apply -f -
exit 0
