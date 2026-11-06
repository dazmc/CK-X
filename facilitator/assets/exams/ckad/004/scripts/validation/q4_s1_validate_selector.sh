#!/bin/bash
D=legacy-web
if ! kubectl get deployment $D -n ckad-api >/dev/null 2>&1; then
  echo "Deployment $D not found in ckad-api"; exit 1
fi
SEL=$(kubectl get deployment $D -n ckad-api -o jsonpath='{.spec.selector.matchLabels.app}')
TPL=$(kubectl get deployment $D -n ckad-api -o jsonpath='{.spec.template.metadata.labels.app}')
[ -n "$SEL" ] || { echo "spec.selector.matchLabels is missing"; exit 1; }
[ "$SEL" = "legacy-web" ] || { echo "selector app is '${SEL}', expected legacy-web"; exit 1; }
[ "$TPL" = "legacy-web" ] || { echo "template label app is '${TPL}', expected legacy-web"; exit 1; }
echo "Selector matches template labels"; exit 0
