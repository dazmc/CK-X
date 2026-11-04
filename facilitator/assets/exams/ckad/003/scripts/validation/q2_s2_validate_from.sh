#!/bin/bash
NP=allow-webapp-color
NAME=$(kubectl get networkpolicy $NP -n default -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.name}' 2>/dev/null)
if [ "$NAME" != "webapp-color" ]; then
  NAME=$(kubectl get networkpolicy $NP -n default -o jsonpath='{.spec.ingress[0].from[1].podSelector.matchLabels.name}' 2>/dev/null)
fi
if [ "$NAME" = "webapp-color" ]; then
  echo "Ingress from pods labeled name=webapp-color"; exit 0
fi
echo "No ingress from podSelector name=webapp-color (found '${NAME:-none}')"; exit 1
