#!/bin/bash
POD_OK=0; SVC_OK=0
kubectl get pod nginx-resolver -n default >/dev/null 2>&1 && POD_OK=1
if kubectl get svc nginx-resolver-service -n default >/dev/null 2>&1; then
  SEL=$(kubectl get svc nginx-resolver-service -n default -o jsonpath='{.spec.selector.run}')
  PORT=$(kubectl get svc nginx-resolver-service -n default -o jsonpath='{.spec.ports[0].port}')
  [ "$SEL" = "nginx-resolver" ] && [ "$PORT" = "80" ] && SVC_OK=1
fi
[ $POD_OK -eq 1 ] || { echo "Pod nginx-resolver not found"; exit 1; }
[ $SVC_OK -eq 1 ] || { echo "Service missing, wrong selector, or wrong port"; exit 1; }
EPS=$(kubectl get endpoints nginx-resolver-service -n default -o jsonpath='{.subsets[0].addresses[*].ip}' 2>/dev/null)
[ -n "$EPS" ] || { echo "Service has no endpoints"; exit 1; }
echo "Pod and service exist with endpoints"; exit 0
