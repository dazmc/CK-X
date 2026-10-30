#!/bin/bash
# Validate service web-svc is of type NodePort with port 80
SVC_TYPE=$(kubectl get svc web-svc -n nodeport-lab -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$SVC_TYPE" != "NodePort" ]; then
    echo "❌ Service web-svc is not of type NodePort (found: '${SVC_TYPE:-none}')"
    exit 1
fi
PORT=$(kubectl get svc web-svc -n nodeport-lab -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$PORT" != "80" ]; then
    echo "❌ Service web-svc should expose port 80 (found: $PORT)"
    exit 1
fi
echo "✅ Service web-svc is NodePort exposing port 80"
exit 0
