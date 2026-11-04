#!/bin/bash
SVC=messaging-service
SEL=$(kubectl get svc $SVC -n default -o jsonpath='{.spec.selector.tier}' 2>/dev/null)
if [ "$SEL" != "msg" ]; then
  echo "Service selector tier='${SEL:-none}', expected msg"; exit 1
fi
EPS=$(kubectl get endpoints $SVC -n default -o jsonpath='{.subsets[0].addresses[*].ip}' 2>/dev/null)
if [ -z "$EPS" ]; then
  echo "Service $SVC has no endpoints"; exit 1
fi
echo "Selector matches and endpoints exist: $EPS"; exit 0
