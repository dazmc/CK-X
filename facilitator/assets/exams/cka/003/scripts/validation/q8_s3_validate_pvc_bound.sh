#!/bin/bash
# Validate the PVC is still Bound
PHASE=$(kubectl get pvc data-pvc -n storage-expand -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$PHASE" != "Bound" ]; then
    echo "❌ PVC data-pvc is not Bound (phase: '${PHASE:-none}')"
    exit 1
fi
echo "✅ PVC data-pvc is Bound"
exit 0
