#!/bin/bash
# Setup for Question 3: pod with cluster-view SA and mounted token
kubectl create namespace gamma --dry-run=client -o yaml | kubectl apply -f -
kubectl create serviceaccount cluster-view -n gamma --dry-run=client -o yaml | kubectl apply -f -
kubectl create clusterrole cv-view --verb=get,list,watch --resource='*' \
  --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null
kubectl create clusterrolebinding cv-binding --clusterrole=cv-view \
  --serviceaccount=gamma:cluster-view --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null
kubectl delete pod apps-cluster-dash -n gamma --ignore-not-found --wait=true >/dev/null 2>&1
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: apps-cluster-dash
  namespace: gamma
  labels:
    run: apps-cluster-dash
spec:
  serviceAccountName: cluster-view
  containers:
  - name: apps-cluster-dash
    image: nginx
EOF
exit 0
