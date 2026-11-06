#!/bin/bash
SVC=$(kubectl get ingress catalog -n ckad-ingress-fix -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null)
if [ "$SVC" = "catalog" ]; then
  echo "Ingress routes to backend service catalog"; exit 0
fi
echo "Ingress backend is '${SVC:-none}', expected catalog"; exit 1
