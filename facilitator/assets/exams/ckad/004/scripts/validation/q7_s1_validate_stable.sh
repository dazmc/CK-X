#!/bin/bash
R=$(kubectl get deployment storefront -n ckad-canary -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$R" = "8" ]; then echo "storefront has 8 replicas"; exit 0; fi
echo "storefront replicas is '${R:-none}', expected 8"; exit 1
