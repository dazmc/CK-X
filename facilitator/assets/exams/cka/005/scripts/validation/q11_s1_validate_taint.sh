#!/bin/bash
TAINTS=$(kubectl get node k3d-cluster-agent-1 -o jsonpath='{range .spec.taints[*]}{.key}={.value}:{.effect}{"\n"}{end}' 2>/dev/null)
if echo "$TAINTS" | grep -q "env_type=production:NoSchedule"; then
  echo "Taint present"; exit 0
fi
echo "Taint env_type=production:NoSchedule not found (have: $(echo $TAINTS))"; exit 1
