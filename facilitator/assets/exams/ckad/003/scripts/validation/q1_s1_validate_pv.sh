#!/bin/bash
PV=log-volume
if ! kubectl get pv $PV >/dev/null 2>&1; then
  echo "PersistentVolume $PV not found"; exit 1
fi
CAP=$(kubectl get pv $PV -o jsonpath='{.spec.capacity.storage}')
MODE=$(kubectl get pv $PV -o jsonpath='{.spec.accessModes[0]}')
SC=$(kubectl get pv $PV -o jsonpath='{.spec.storageClassName}')
HP=$(kubectl get pv $PV -o jsonpath='{.spec.hostPath.path}')
[ "$CAP" = "1Gi" ] || { echo "Capacity is '$CAP', expected 1Gi"; exit 1; }
[ "$MODE" = "ReadWriteMany" ] || { echo "Access mode is '$MODE', expected ReadWriteMany"; exit 1; }
[ "$SC" = "manual" ] || { echo "storageClassName is '$SC', expected manual"; exit 1; }
[ "$HP" = "/opt/volume/nginx" ] || { echo "hostPath is '$HP', expected /opt/volume/nginx"; exit 1; }
echo "PV log-volume is correct"; exit 0
