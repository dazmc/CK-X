#!/bin/bash
SVC=hr-web-app-service
SEL=$(kubectl get svc $SVC -n default -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$SEL" != "hr-web-app" ]; then
  echo "Selector app='${SEL:-none}', expected hr-web-app"; exit 1
fi
EPS=$(kubectl get endpoints $SVC -n default -o jsonpath='{.subsets[0].addresses[*].ip}' 2>/dev/null)
if [ -z "$EPS" ]; then
  echo "Service $SVC has no endpoints"; exit 1
fi
echo "Selector matches and endpoints exist: $EPS"; exit 0
