#!/bin/bash
# Validate the pods are running on k3d-cluster-agent-1
OFF=$(kubectl get pods -n maintenance -l app=critical-app --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' | grep -cv "k3d-cluster-agent-1" || true)
TOTAL=$(kubectl get pods -n maintenance -l app=critical-app --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l)
if [ "$TOTAL" -lt 3 ]; then
    echo "❌ Expected 3 Running pods, found $TOTAL"
    exit 1
fi
if [ "$OFF" -ne 0 ]; then
    echo "❌ Some critical-app pods are not on k3d-cluster-agent-1"
    kubectl get pods -n maintenance -l app=critical-app -o wide
    exit 1
fi
echo "✅ All critical-app pods run on k3d-cluster-agent-1"
exit 0
