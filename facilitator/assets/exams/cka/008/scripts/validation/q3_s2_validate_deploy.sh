#!/bin/bash
R=$(kubectl get deploy webapp -n kustomize-demo -o jsonpath='{.spec.replicas}' 2>/dev/null)
IMG=$(kubectl get deploy webapp -n kustomize-demo -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
NS=$(kubectl get deploy webapp -n kustomize-demo -o jsonpath='{.metadata.namespace}' 2>/dev/null)
READY=$(kubectl get deploy webapp -n kustomize-demo -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "$NS" != "kustomize-demo" ]; then
  echo "deployment is in namespace '${NS:-none}', expected kustomize-demo (the kustomization sets namespace)"
  exit 1
fi
if [ "$R" != "2" ]; then
  echo "replicas is '${R:-none}', expected 2"
  exit 1
fi
if [ "$IMG" != "nginx:1.27" ]; then
  echo "image is '${IMG:-none}', expected nginx:1.27"
  exit 1
fi
if [ "${READY:-0}" -lt 2 ]; then
  echo "only ${READY:-0}/2 replicas ready"
  exit 1
fi
echo "Deployment: 2 ready replicas of nginx:1.27 in kustomize-demo"
exit 0
