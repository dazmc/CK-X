#!/bin/bash
DEP=hr-web-app
AVAIL=$(kubectl get deployment $DEP -n default -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
if [ "$AVAIL" = "2" ]; then echo "2/2 replicas available"; exit 0; fi
echo "availableReplicas is '${AVAIL:-0}', expected 2"; exit 1
