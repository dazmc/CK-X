#!/bin/bash
NS=$(kubectl get pod my-busybox -n dev2406 -o jsonpath='{.spec.nodeSelector.kubernetes\.io/hostname}' 2>/dev/null)
NODE=$(kubectl get pod my-busybox -n dev2406 -o jsonpath='{.spec.nodeName}' 2>/dev/null)
[ "$NS" = "k3d-cluster-server-0" ] || { echo "nodeSelector is '${NS:-none}', expected k3d-cluster-server-0"; exit 1; }
[ -z "$NODE" ] && { echo "Pod is not scheduled yet"; exit 1; }
[ "$NODE" = "k3d-cluster-server-0" ] || { echo "Pod runs on '$NODE', expected k3d-cluster-server-0"; exit 1; }
echo "Pod scheduled on k3d-cluster-server-0"; exit 0
