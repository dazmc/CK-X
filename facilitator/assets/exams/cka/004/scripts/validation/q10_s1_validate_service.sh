#!/bin/bash
SVC=hr-web-app-service
if ! kubectl get svc $SVC -n default >/dev/null 2>&1; then
  echo "Service $SVC not found"; exit 1
fi
TYPE=$(kubectl get svc $SVC -n default -o jsonpath='{.spec.type}')
PORT=$(kubectl get svc $SVC -n default -o jsonpath='{.spec.ports[0].port}')
TPORT=$(kubectl get svc $SVC -n default -o jsonpath='{.spec.ports[0].targetPort}')
NPORT=$(kubectl get svc $SVC -n default -o jsonpath='{.spec.ports[0].nodePort}')
[ "$TYPE" = "NodePort" ] || { echo "Type is '$TYPE', expected NodePort"; exit 1; }
[ "$PORT" = "8080" ] || { echo "Port is '$PORT', expected 8080"; exit 1; }
[ "$TPORT" = "8080" ] || { echo "targetPort is '$TPORT', expected 8080"; exit 1; }
[ "$NPORT" = "30082" ] || { echo "nodePort is '$NPORT', expected 30082"; exit 1; }
echo "Service is NodePort 8080/8080 nodePort 30082"; exit 0
