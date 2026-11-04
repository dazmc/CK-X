#!/bin/bash
# Setup for Question 8: namespace + secret pre-created as per the question
kubectl create namespace dev2406 --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic dotfile-secret -n dev2406 \
  --from-literal=username=my-group \
  --dry-run=client -o yaml | kubectl apply -f -
exit 0
