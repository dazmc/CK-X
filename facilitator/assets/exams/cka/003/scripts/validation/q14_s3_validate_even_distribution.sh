#!/bin/bash
# Validate pods are spread evenly (max difference of 1) across nodes
DISTRIBUTION=$(kubectl get pods -n spread -l app=spread-app --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' | sort | uniq -c | awk '{print $1}' | sort -n)
NODE_COUNT=$(echo "$DISTRIBUTION" | wc -l)
MIN=$(echo "$DISTRIBUTION" | head -1)
MAX=$(echo "$DISTRIBUTION" | tail -1)
DIFF=$((MAX - MIN))
if [ "$NODE_COUNT" -lt 2 ]; then
    echo "❌ Pods are all on a single node; expected spread across multiple nodes"
    exit 1
fi
if [ "$DIFF" -gt 1 ]; then
    echo "❌ Pod distribution is uneven (max skew $DIFF > 1)"
    kubectl get pods -n spread -l app=spread-app -o wide
    exit 1
fi
echo "✅ Pods evenly distributed across $NODE_COUNT nodes"
exit 0
