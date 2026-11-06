#!/bin/bash
S=postgres-credentials
if ! kubectl get secret $S -n ckad-secret >/dev/null 2>&1; then
  echo "Secret $S not found in ckad-secret"; exit 1
fi
DB=$(kubectl get secret $S -n ckad-secret -o jsonpath='{.data.database}' | base64 -d 2>/dev/null)
PW=$(kubectl get secret $S -n ckad-secret -o jsonpath='{.data.password}' | base64 -d 2>/dev/null)
[ "$DB" = "inventory" ] || { echo "database key is '$DB', expected inventory"; exit 1; }
[ "$PW" = "ckad-password" ] || { echo "password key is '$PW', expected ckad-password"; exit 1; }
echo "Secret has database=inventory and password=ckad-password"; exit 0
