#!/bin/bash
BL=$(kubectl get cronjob dice -n default -o jsonpath='{.spec.jobTemplate.spec.backoffLimit}' 2>/dev/null)
if [ "$BL" = "25" ]; then echo "backoffLimit is 25"; exit 0; fi
echo "backoffLimit is '${BL:-none}', expected 25"; exit 1
