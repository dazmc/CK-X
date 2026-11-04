#!/bin/bash
READY=$(kubectl get pod use-pv -n default -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
if [ "$READY" = "True" ]; then echo "Pod is Ready"; exit 0; fi
echo "Pod Ready condition is '${READY:-missing}', expected True (phase may still say Running while the container crashes)"; exit 1
