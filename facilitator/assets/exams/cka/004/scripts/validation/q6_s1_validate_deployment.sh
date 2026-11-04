#!/bin/bash
DEP=hr-web-app
if ! kubectl get deployment $DEP -n default >/dev/null 2>&1; then
  echo "Deployment $DEP not found"; exit 1
fi
REPS=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.replicas}')
IMG=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$REPS" != "2" ]; then echo "Replicas is '$REPS', expected 2"; exit 1; fi
if [ "$IMG" != "kodekloud/webapp-color" ]; then echo "Image is '$IMG', expected kodekloud/webapp-color"; exit 1; fi
echo "Deployment exists with 2 replicas and correct image"; exit 0
