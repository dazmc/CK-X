#!/bin/bash
# Validate all pods are Running and not in ImagePullBackOff
BAD=$(kubectl get pods -n image-fix -l app=web-recovery --no-headers 2>/dev/null | grep -cE "ImagePull|ErrImage|Error|CrashLoop" || true)
if [ "$BAD" -ne 0 ]; then
    echo "❌ Some pods are still failing (ImagePull/CrashLoop/Error)"
    kubectl get pods -n image-fix -l app=web-recovery
    exit 1
fi
COUNT=$(kubectl get pods -n image-fix -l app=web-recovery --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l)
if [ "$COUNT" -lt 2 ]; then
    echo "❌ Expected 2 Running pods, found $COUNT"
    exit 1
fi
echo "✅ All web-recovery pods are Running"
exit 0
