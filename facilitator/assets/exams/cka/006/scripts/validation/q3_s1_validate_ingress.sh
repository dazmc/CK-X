#!/bin/bash
if ! kubectl get ingress web-ingress -n ingress-ex19 >/dev/null 2>&1; then
  echo "Ingress web-ingress not found in ingress-ex19"
  exit 1
fi
CLASS=$(kubectl get ingress web-ingress -n ingress-ex19 -o jsonpath='{.spec.ingressClassName}' 2>/dev/null)
if [ "$CLASS" != "nginx" ]; then
  echo "ingressClassName is '${CLASS:-none}', expected nginx"
  exit 1
fi
echo "Ingress web-ingress exists with ingressClassName nginx"
exit 0
