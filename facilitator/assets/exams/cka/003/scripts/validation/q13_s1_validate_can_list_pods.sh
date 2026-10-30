#!/bin/bash
# Validate the SA can still list pods
ANSWER=$(kubectl auth can-i list pods -n rbac-debug --as=system:serviceaccount:rbac-debug:pod-viewer 2>/dev/null)
if [ "$ANSWER" != "yes" ]; then
    echo "❌ ServiceAccount pod-viewer should be able to list pods (answer: $ANSWER)"
    exit 1
fi
echo "✅ ServiceAccount pod-viewer can list pods"
exit 0
