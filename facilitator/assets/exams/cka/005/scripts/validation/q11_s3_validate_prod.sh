#!/bin/bash
if ! kubectl get pod prod-redis -n default >/dev/null 2>&1; then
  echo "Pod prod-redis not found"; exit 1
fi
TOL=$(kubectl get pod prod-redis -n default -o jsonpath='{range .spec.tolerations[*]}{.key}={.value}:{.effect}{"\n"}{end}')
SEL=$(kubectl get pod prod-redis -n default -o jsonpath='{.spec.nodeSelector.kubernetes\.io/hostname}')
NODE=$(kubectl get pod prod-redis -n default -o jsonpath='{.spec.nodeName}')
echo "$TOL" | grep -q "env_type=production:NoSchedule" || { echo "Missing toleration (have: $(echo $TOL))"; exit 1; }
[ "$SEL" = "k3d-cluster-agent-1" ] || { echo "nodeSelector is '${SEL:-none}', expected k3d-cluster-agent-1"; exit 1; }
[ "$NODE" = "k3d-cluster-agent-1" ] || { echo "prod-redis runs on '${NODE:-none}', expected k3d-cluster-agent-1"; exit 1; }
echo "prod-redis has the toleration and runs on k3d-cluster-agent-1"; exit 0
