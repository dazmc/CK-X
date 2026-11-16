#!/bin/bash
SEL=$(kubectl get svc webapp -n kustomize-demo -o jsonpath='{.spec.selector.app}' 2>/dev/null)
PORT=$(kubectl get svc webapp -n kustomize-demo -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
TPL=$(kubectl get deploy webapp -n kustomize-demo -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
if [ "$PORT" != "80" ]; then
  echo "service port is '${PORT:-none}', expected 80"
  exit 1
fi
if [ "$SEL" != "webapp" ] || [ "$SEL" != "$TPL" ]; then
  echo "service selector is '${SEL:-none}', pod template label is '${TPL:-none}' - they must match"
  exit 1
fi
READY=$(kubectl get endpointslice -n kustomize-demo -l kubernetes.io/service-name=webapp -o json 2>/dev/null | jq -r '[.items[] | .endpoints[]? | select(.conditions.ready==true)] | length')
if [ "${READY:-0}" -lt 1 ]; then
  echo "service webapp has no ready endpoints"
  exit 1
fi
echo "Service selects the deployment pods on port 80 with ready endpoints"
exit 0
