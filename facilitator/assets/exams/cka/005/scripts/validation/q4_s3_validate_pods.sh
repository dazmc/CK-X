#!/bin/bash
BAD=$(kubectl get pods -n default -l app=nginx-deploy -o jsonpath='{range .items[*]}{.spec.containers[0].image}{"\n"}{end}' 2>/dev/null | grep -cv '^nginx:1.17$')
TOTAL=$(kubectl get pods -n default -l app=nginx-deploy --no-headers 2>/dev/null | wc -l)
if [ "$TOTAL" -eq 0 ]; then echo "No nginx-deploy pods found"; exit 1; fi
if [ "$BAD" -eq 0 ]; then echo "All $TOTAL pods run nginx:1.17"; exit 0; fi
echo "$BAD of $TOTAL pods do not run nginx:1.17"; exit 1
