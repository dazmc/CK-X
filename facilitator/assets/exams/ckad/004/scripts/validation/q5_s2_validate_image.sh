#!/bin/bash
IMG=$(kubectl get deployment api -n ckad-container -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$IMG" = "nginx:1.25-alpine" ]; then echo "image is nginx:1.25-alpine"; exit 0; fi
echo "image is '${IMG:-none}', expected nginx:1.25-alpine"; exit 1
