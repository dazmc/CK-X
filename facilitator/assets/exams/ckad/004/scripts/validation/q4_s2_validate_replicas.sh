#!/bin/bash
AVAIL=$(kubectl get deployment legacy-web -n ckad-api -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
if [ "$AVAIL" = "2" ]; then echo "2 replicas available"; exit 0; fi
echo "availableReplicas is '${AVAIL:-0}', expected 2"; exit 1
