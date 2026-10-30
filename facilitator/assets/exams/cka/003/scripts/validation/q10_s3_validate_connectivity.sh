#!/bin/bash
# Validate the tester pod (access=granted) can actually reach the backend
kubectl exec tester -n netpol-debug -- wget -q -T 10 -O /dev/null http://backend.netpol-debug.svc.cluster.local/ >/dev/null 2>&1
RC=$?
if [ $RC -ne 0 ]; then
    echo "❌ Pod 'tester' cannot reach the backend service (wget exit code $RC)"
    exit 1
fi
echo "✅ Pod 'tester' can reach the backend"
exit 0
