#!/bin/bash
PHASE=$(kubectl get namespace apx-x9984574 -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$PHASE" = "Active" ]; then echo "Namespace is Active"; exit 0; fi
echo "Namespace phase is '${PHASE:-missing}', expected Active"; exit 1
