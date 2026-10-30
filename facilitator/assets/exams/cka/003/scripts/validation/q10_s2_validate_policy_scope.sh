#!/bin/bash
# Validate the policy still targets only backend pods and port 80
SELECTOR=$(kubectl get netpol backend-access -n netpol-debug -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)
if [ "$SELECTOR" != "backend" ]; then
    echo "❌ Policy podSelector should still target app=backend (found: '${SELECTOR:-none}')"
    exit 1
fi
PORT=$(kubectl get netpol backend-access -n netpol-debug -o jsonpath='{.spec.ingress[0].ports[0].port}' 2>/dev/null)
if [ "$PORT" != "80" ]; then
    echo "❌ Policy should allow port 80 (found: '${PORT:-none}')"
    exit 1
fi
echo "✅ Policy scope preserved (backend pods, port 80)"
exit 0
