#!/bin/bash
kubectl get networkpolicy default-deny-all -n default >/dev/null 2>&1 || { echo "default-deny-all policy was deleted"; exit 1; }
kubectl get pod secure-pod -n default >/dev/null 2>&1 || { echo "pod secure-pod was deleted"; exit 1; }
kubectl get svc secure-service -n default >/dev/null 2>&1 || { echo "service secure-service was deleted"; exit 1; }
kubectl get pod webapp-color -n default >/dev/null 2>&1 || { echo "pod webapp-color was deleted"; exit 1; }
echo "Existing objects are untouched"; exit 0
