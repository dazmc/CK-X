#!/bin/bash
CO=$(kubectl get cronjob dice -n default -o jsonpath='{.spec.jobTemplate.spec.completions}' 2>/dev/null)
if [ "$CO" = "1" ]; then echo "completions is 1"; exit 0; fi
echo "completions is '${CO:-none}', expected 1"; exit 1
