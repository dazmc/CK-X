#!/bin/bash
# Validate an ephemeral container was added to the crashlooping pod
EPHEMERAL=$(kubectl get pod app-crasher -n debug-pod -o jsonpath='{.spec.ephemeralContainers[0].name}' 2>/dev/null)
if [ -z "$EPHEMERAL" ]; then
    echo "❌ No ephemeral container found on pod app-crasher (did you use kubectl debug?)"
    exit 1
fi
echo "✅ Ephemeral container '$EPHEMERAL' found on pod app-crasher"
exit 0
