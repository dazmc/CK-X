#!/bin/bash
NP=allow-redis-access
FOUND=0
RULES=$(kubectl get networkpolicy $NP -n prod-x12cs -o jsonpath='{range .spec.ingress[*]}{range .from[*]}{.namespaceSelector.matchLabels.access}{"
"}{end}{end}' 2>/dev/null)
while IFS= read -r L; do
  [ "$L" = "redis" ] && FOUND=1
done <<< "$RULES"
if [ $FOUND -eq 1 ]; then
  echo "Ingress from namespaces labeled access=redis"; exit 0
fi
echo "No ingress rule with namespaceSelector access=redis"; exit 1
