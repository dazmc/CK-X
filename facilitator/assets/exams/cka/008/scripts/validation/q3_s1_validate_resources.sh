#!/bin/bash
D=$(kubectl get deploy webapp -n kustomize-demo -o name 2>/dev/null)
S=$(kubectl get svc webapp -n kustomize-demo -o name 2>/dev/null)
if [ "$D" != "deployment.apps/webapp" ]; then
  echo "deployment webapp not found in kustomize-demo - apply the kustomization with: kubectl apply -k /tmp/exam/kustomize/base"
  exit 1
fi
if [ "$S" != "service/webapp" ]; then
  echo "service webapp not found in kustomize-demo"
  exit 1
fi
STRAY=""
kubectl get deploy webapp -n default >/dev/null 2>&1 && STRAY="$STRAY deployment"
kubectl get svc webapp -n default >/dev/null 2>&1 && STRAY="$STRAY service"
if [ -n "$STRAY" ]; then
  echo "raw YAML was applied to default as well (stray:$STRAY) - only the kustomization output belongs in kustomize-demo"
  exit 1
fi
echo "Deployment and Service exist in kustomize-demo, nothing stray in default"
exit 0
