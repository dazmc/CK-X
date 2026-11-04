#!/bin/bash
if ! kubectl get pod dev-redis -n default >/dev/null 2>&1; then
  echo "Pod dev-redis not found"; exit 1
fi
NODE=$(kubectl get pod dev-redis -n default -o jsonpath='{.spec.nodeName}')
if [ -z "$NODE" ]; then echo "dev-redis is not scheduled yet"; exit 1; fi
if [ "$NODE" = "k3d-cluster-agent-1" ]; then
  echo "dev-redis is scheduled on the tainted node k3d-cluster-agent-1"; exit 1
fi
echo "dev-redis exists and runs on $NODE (not the tainted node)"; exit 0
