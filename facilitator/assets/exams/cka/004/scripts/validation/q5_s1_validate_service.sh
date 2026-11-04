#!/bin/bash
SVC=messaging-service
if ! kubectl get svc $SVC -n default >/dev/null 2>&1; then
  echo "Service $SVC not found"; exit 1
fi
PORT=$(kubectl get svc $SVC -n default -o jsonpath='{.spec.ports[0].port}')
if [ "$PORT" != "6379" ]; then
  echo "Service port is '$PORT', expected 6379"; exit 1
fi
echo "Service exposes port 6379"; exit 0
