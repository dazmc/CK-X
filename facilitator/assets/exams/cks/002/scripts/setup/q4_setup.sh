#!/bin/bash
# Setup for Question 4: over-permissive role in dev-z (dev-a/dev-b are correct)
for NS in dev-a dev-b dev-z; do
  kubectl create namespace $NS --dry-run=client -o yaml | kubectl apply -f -
  kubectl create role dev-user-access -n $NS --resource=pods --verb='*' \
    --dry-run=client -o yaml | kubectl apply -f -
  kubectl create rolebinding dev-user-access -n $NS --role=dev-user-access \
    --user=martin --dry-run=client -o yaml | kubectl apply -f -
done
exit 0
