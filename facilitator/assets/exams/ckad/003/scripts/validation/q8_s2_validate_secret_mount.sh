#!/bin/bash
SN=$(kubectl get pod my-busybox -n dev2406 -o jsonpath='{.spec.volumes[0].secret.secretName}' 2>/dev/null)
MP=$(kubectl get pod my-busybox -n dev2406 -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
RO=$(kubectl get pod my-busybox -n dev2406 -o jsonpath='{.spec.containers[0].volumeMounts[0].readOnly}' 2>/dev/null)
VN=$(kubectl get pod my-busybox -n dev2406 -o jsonpath='{.spec.volumes[0].name}' 2>/dev/null)
[ "$SN" = "dotfile-secret" ] || { echo "Volume secretName is '${SN:-none}', expected dotfile-secret"; exit 1; }
[ "$VN" = "secret-volume" ] || { echo "Volume name is '${VN:-none}', expected secret-volume"; exit 1; }
[ "$MP" = "/etc/secret-volume" ] || { echo "mountPath is '${MP:-none}', expected /etc/secret-volume"; exit 1; }
[ "$RO" = "true" ] || { echo "readOnly is '${RO:-not set}', expected true"; exit 1; }
echo "Secret mounted read-only at /etc/secret-volume"; exit 0
