#!/bin/bash
# Setup for Question 1: RBAC namespace (source: theplatformlab exercise 04)
kubectl create namespace rbac-ex04 --dry-run=client -o yaml | kubectl apply -f -
exit 0
