#!/bin/bash
CPU=$(kubectl get deployment redis -n default -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
if [ "$CPU" = "200m" ] || [ "$CPU" = "0.2" ]; then
  echo "CPU request is $CPU"; exit 0
fi
echo "CPU request is '${CPU:-none}', expected 200m (0.2 CPU)"; exit 1
