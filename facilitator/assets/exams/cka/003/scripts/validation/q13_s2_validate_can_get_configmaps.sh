#!/bin/bash
# Validate the SA can now get configmaps (the 403 fix)
ANSWER=$(kubectl auth can-i get configmaps -n rbac-debug --as=system:serviceaccount:rbac-debug:pod-viewer 2>/dev/null)
if [ "$ANSWER" != "yes" ]; then
    echo "❌ ServiceAccount pod-viewer should be able to get configmaps (answer: $ANSWER)"
    exit 1
fi
echo "✅ ServiceAccount pod-viewer can get configmaps"
exit 0
