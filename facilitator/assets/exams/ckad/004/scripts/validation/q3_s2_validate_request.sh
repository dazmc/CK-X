#!/bin/bash
R=$(kubectl get pod worker -n ckad-pod-cpu -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
if [ "$R" = "200m" ]; then echo "requests.cpu is still 200m"; exit 0; fi
echo "requests.cpu is '${R:-none}', expected 200m (unchanged)"; exit 1
