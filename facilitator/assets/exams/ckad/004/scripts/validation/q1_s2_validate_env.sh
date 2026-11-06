#!/bin/bash
D=postgres-client
DBN=$(kubectl get deployment $D -n ckad-secret -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="POSTGRES_DB")].valueFrom.secretKeyRef.name}' 2>/dev/null)
DBK=$(kubectl get deployment $D -n ckad-secret -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="POSTGRES_DB")].valueFrom.secretKeyRef.key}' 2>/dev/null)
DBV=$(kubectl get deployment $D -n ckad-secret -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="POSTGRES_DB")].value}' 2>/dev/null)
PWK=$(kubectl get deployment $D -n ckad-secret -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="POSTGRES_PASSWORD")].valueFrom.secretKeyRef.name}' 2>/dev/null)
PWKK=$(kubectl get deployment $D -n ckad-secret -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="POSTGRES_PASSWORD")].valueFrom.secretKeyRef.key}' 2>/dev/null)
PWV=$(kubectl get deployment $D -n ckad-secret -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="POSTGRES_PASSWORD")].value}' 2>/dev/null)
[ -z "$DBV" ] || { echo "POSTGRES_DB still has literal value '$DBV'"; exit 1; }
[ -z "$PWV" ] || { echo "POSTGRES_PASSWORD still has literal value '$PWV'"; exit 1; }
[ "$DBN" = "postgres-credentials" ] || { echo "POSTGRES_DB secret name is '${DBN:-none}', expected postgres-credentials"; exit 1; }
[ "$DBK" = "database" ] || { echo "POSTGRES_DB key is '${DBK:-none}', expected database"; exit 1; }
[ "$PWK" = "postgres-credentials" ] || { echo "POSTGRES_PASSWORD secret name is '${PWK:-none}', expected postgres-credentials"; exit 1; }
[ "$PWKK" = "password" ] || { echo "POSTGRES_PASSWORD key is '${PWKK:-none}', expected password"; exit 1; }
echo "Both env vars sourced from Secret postgres-credentials"; exit 0
