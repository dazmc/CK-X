#!/bin/bash
VN=$(kubectl get pod time-check -n dvl1987 -o jsonpath='{.spec.volumes[0].name}' 2>/dev/null)
ED=$(kubectl get pod time-check -n dvl1987 -o jsonpath='{.spec.volumes[0].emptyDir}' 2>/dev/null)
MN=$(kubectl get pod time-check -n dvl1987 -o jsonpath='{.spec.containers[0].volumeMounts[0].name}' 2>/dev/null)
MP=$(kubectl get pod time-check -n dvl1987 -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
[ "$VN" = "log-volume" ] || { echo "Volume name is '${VN:-none}', expected log-volume"; exit 1; }
[ -n "$ED" ] || { echo "Volume is not an emptyDir"; exit 1; }
[ "$MN" = "log-volume" ] || { echo "Mount references '${MN:-none}', expected log-volume"; exit 1; }
[ "$MP" = "/opt/time" ] || { echo "mountPath is '${MP:-none}', expected /opt/time"; exit 1; }
echo "emptyDir log-volume mounted at /opt/time"; exit 0
