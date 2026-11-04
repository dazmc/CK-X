#!/bin/bash
PORT=$(kubectl get networkpolicy ingress-to-nptest -n default -o jsonpath='{.spec.ingress[0].ports[0].port}' 2>/dev/null)
PROTO=$(kubectl get networkpolicy ingress-to-nptest -n default -o jsonpath='{.spec.ingress[0].ports[0].protocol}' 2>/dev/null)
[ "$PORT" = "80" ] || { echo "Allowed port is '${PORT:-none}', expected 80"; exit 1; }
if [ -n "$PROTO" ] && [ "$PROTO" != "TCP" ]; then
  echo "Protocol is '$PROTO', expected TCP (or omit for the TCP default)"; exit 1
fi
echo "Ingress rule allows TCP port 80"; exit 0
