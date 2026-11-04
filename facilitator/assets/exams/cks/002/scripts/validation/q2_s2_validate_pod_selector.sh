#!/bin/bash
NP=allow-redis-access
FOUND=0
RULES=$(kubectl get networkpolicy $NP -n prod-x12cs -o jsonpath='{range .spec.ingress[*]}{range .from[*]}{.podSelector.matchLabels.backend}{"
"}{end}{end}' 2>/dev/null)
while IFS= read -r L; do
  [ "$L" = "prod-x12cs" ] && FOUND=1
done <<< "$RULES"
if [ $FOUND -eq 1 ]; then
  echo "Ingress from pods labeled backend=prod-x12cs"; exit 0
fi
echo "No ingress rule with podSelector backend=prod-x12cs"; exit 1
