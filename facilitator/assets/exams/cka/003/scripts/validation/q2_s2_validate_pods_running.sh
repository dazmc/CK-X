#!/bin/bash
# Validate all app=web pods are in Running state
NOT_RUNNING=$(kubectl get pods -n pod-basics -l app=web --no-headers 2>/dev/null | awk '$3 != "Running"' | wc -l)
if [ "$NOT_RUNNING" -ne 0 ]; then
    echo "❌ Not all app=web pods are in Running state"
    kubectl get pods -n pod-basics -l app=web
    exit 1
fi
echo "✅ All app=web pods are Running"
exit 0
