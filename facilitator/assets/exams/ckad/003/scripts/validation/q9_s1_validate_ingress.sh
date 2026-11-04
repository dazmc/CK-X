#!/bin/bash
if kubectl get ingress ingress-vh-routing -n default >/dev/null 2>&1; then
  echo "Ingress ingress-vh-routing exists"; exit 0
fi
echo "Ingress ingress-vh-routing not found"; exit 1
