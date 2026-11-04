#!/bin/bash
PV=pv-analytics
if ! kubectl get pv $PV >/dev/null 2>&1; then
  echo "PersistentVolume $PV not found"; exit 1
fi
CAP=$(kubectl get pv $PV -o jsonpath='{.spec.capacity.storage}')
MODE=$(kubectl get pv $PV -o jsonpath='{.spec.accessModes[0]}')
[ "$CAP" = "100Mi" ] || { echo "Capacity is '$CAP', expected 100Mi"; exit 1; }
[ "$MODE" = "ReadWriteMany" ] || { echo "Access mode is '$MODE', expected ReadWriteMany"; exit 1; }
echo "PV exists with 100Mi ReadWriteMany"; exit 0
