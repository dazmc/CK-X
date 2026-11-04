#!/bin/bash
PORT=$(kubectl get networkpolicy allow-redis-access -n prod-x12cs -o jsonpath='{.spec.ingress[0].ports[0].port}' 2>/dev/null)
PROTO=$(kubectl get networkpolicy allow-redis-access -n prod-x12cs -o jsonpath='{.spec.ingress[0].ports[0].protocol}' 2>/dev/null)
[ "$PORT" = "6379" ] || { echo "Allowed port is '${PORT:-none}', expected 6379"; exit 1; }
if [ -n "$PROTO" ] && [ "$PROTO" != "TCP" ]; then
  echo "Protocol is '$PROTO', expected TCP (or omit for the TCP default)"; exit 1
fi
echo "Ingress restricted to TCP port 6379"; exit 0
