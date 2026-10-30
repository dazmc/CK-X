#!/bin/bash
# Validate 3 pods with label app=web exist in namespace pod-basics
COUNT=$(kubectl get pods -n pod-basics -l app=web --no-headers 2>/dev/null | wc -l)
if [ "$COUNT" -ne 3 ]; then
    echo "❌ Expected 3 pods with label app=web in namespace pod-basics, found $COUNT"
    exit 1
fi
echo "✅ 3 pods with label app=web exist in pod-basics"
exit 0
