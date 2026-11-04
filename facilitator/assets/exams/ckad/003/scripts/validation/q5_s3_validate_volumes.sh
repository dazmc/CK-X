#!/bin/bash
D1=$(kubectl get deployment redis -n default -o jsonpath='{.spec.template.spec.volumes[?(@.name=="data")].emptyDir}' 2>/dev/null)
CM=$(kubectl get deployment redis -n default -o jsonpath='{.spec.template.spec.volumes[?(@.name=="config")].configMap.name}' 2>/dev/null)
M1=$(kubectl get deployment redis -n default -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[?(@.name=="data")].mountPath}' 2>/dev/null)
M2=$(kubectl get deployment redis -n default -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[?(@.name=="config")].mountPath}' 2>/dev/null)
NVOL=$(kubectl get deployment redis -n default -o jsonpath='{.spec.template.spec.volumes[*].name}' 2>/dev/null | wc -w)
[ -n "$D1" ] || { echo "Volume 'data' is missing or not an emptyDir"; exit 1; }
[ "$CM" = "redis-config" ] || { echo "Volume 'config' references '${CM:-none}', expected redis-config"; exit 1; }
[ "$M1" = "/redis-master-data" ] || { echo "data mountPath is '${M1:-none}', expected /redis-master-data"; exit 1; }
[ "$M2" = "/redis-master" ] || { echo "config mountPath is '${M2:-none}', expected /redis-master"; exit 1; }
[ "$NVOL" -eq 2 ] || { echo "Pod defines $NVOL volumes, expected exactly 2"; exit 1; }
echo "Both volumes mounted correctly"; exit 0
