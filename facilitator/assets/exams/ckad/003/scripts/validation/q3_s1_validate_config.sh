#!/bin/bash
kubectl get namespace dvl1987 >/dev/null 2>&1 || { echo "Namespace dvl1987 not found"; exit 1; }
V=$(kubectl get configmap time-config -n dvl1987 -o jsonpath='{.data.TIME_FREQ}' 2>/dev/null)
[ "$V" = "10" ] || { echo "ConfigMap TIME_FREQ is '${V:-missing}', expected 10"; exit 1; }
echo "Namespace and ConfigMap are correct"; exit 0
