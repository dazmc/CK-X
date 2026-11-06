#!/bin/bash
NAMES=$(kubectl get deployment api -n ckad-container -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{"\n"}{end}' 2>/dev/null)
COUNT=$(echo "$NAMES" | grep -c . || true)
if [ "$COUNT" != "1" ]; then
  echo "Pod template has $COUNT containers, expected exactly 1"; exit 1
fi
if [ "$NAMES" = "web-container" ]; then
  echo "Single container named web-container"; exit 0
fi
echo "Container is named '${NAMES}', expected web-container"; exit 1
