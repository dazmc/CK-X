#!/bin/bash
VTYPE=$(kubectl get pod redis-storage -n default -o jsonpath='{.spec.volumes[0].emptyDir}' 2>/dev/null)
VNAME=$(kubectl get pod redis-storage -n default -o jsonpath='{.spec.volumes[0].name}' 2>/dev/null)
MOUNT=$(kubectl get pod redis-storage -n default -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
MNAME=$(kubectl get pod redis-storage -n default -o jsonpath='{.spec.containers[0].volumeMounts[0].name}' 2>/dev/null)
[ "$VNAME" = "redis-storage" ] || { echo "Volume name is '${VNAME:-none}', expected redis-storage"; exit 1; }
[ -n "$VTYPE" ] || { echo "Volume is not an emptyDir"; exit 1; }
[ "$MNAME" = "redis-storage" ] || { echo "Mount references '${MNAME:-none}', expected redis-storage"; exit 1; }
[ "$MOUNT" = "/data/redis" ] || { echo "mountPath is '${MOUNT:-none}', expected /data/redis"; exit 1; }
echo "emptyDir volume mounted at /data/redis"; exit 0
