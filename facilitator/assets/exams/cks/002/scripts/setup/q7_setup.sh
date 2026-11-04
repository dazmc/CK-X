#!/bin/bash
# Setup for Question 7: SAs + rolebindings; pod uses the wrong (privileged) SA
kubectl create namespace omni --dry-run=client -o yaml | kubectl apply -f -
for SA in fe frontend frontend-default; do
  kubectl create serviceaccount $SA -n omni --dry-run=client -o yaml | kubectl apply -f -
done
kubectl create role fe -n omni --resource=pods --verb=get,list,create,delete \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl create role frontend -n omni --resource=configmaps --verb=get,list,update \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl create rolebinding fe -n omni --role=fe --serviceaccount=omni:fe \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl create rolebinding frontend -n omni --role=frontend --serviceaccount=omni:frontend \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl delete pod frontend-site -n omni --ignore-not-found --wait=true >/dev/null 2>&1
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: frontend-site
  namespace: omni
  labels:
    run: nginx
spec:
  serviceAccountName: fe
  containers:
  - name: nginx
    image: nginx:alpine
EOF
exit 0
