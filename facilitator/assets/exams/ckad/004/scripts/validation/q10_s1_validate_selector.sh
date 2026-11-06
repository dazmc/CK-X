#!/bin/bash
SEL=$(kubectl get service catalog -n ckad-ingress-fix -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$SEL" = "catalog" ]; then
  echo "Service selector matches Pod label app=catalog"; exit 0
fi
echo "Service selector app is '${SEL:-none}', expected catalog"; exit 1
