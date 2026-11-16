#!/bin/bash
# Setup for Question 1: rbac-test namespace (Role/RoleBinding created by candidate)
# (source: techiescamp PRACTICE_QUESTIONS Q1)
kubectl create namespace rbac-test --dry-run=client -o yaml | kubectl apply -f -
exit 0
