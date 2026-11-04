#!/bin/bash
ANN=$(kubectl get ingress ingress-vh-routing -n default -o jsonpath='{.metadata.annotations.nginx\.ingress\.kubernetes\.io/rewrite-target}' 2>/dev/null)
if [ "$ANN" = "/" ]; then
  echo "rewrite-target annotation is /"; exit 0
fi
echo "rewrite-target annotation is '${ANN:-missing}', expected /"; exit 1
