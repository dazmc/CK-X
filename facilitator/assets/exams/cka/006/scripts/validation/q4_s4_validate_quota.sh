#!/bin/bash
CPU=$(kubectl get resourcequota compute-quota -n resource-tuning -o jsonpath='{.spec.hard.requests\.cpu}' 2>/dev/null)
MEM=$(kubectl get resourcequota compute-quota -n resource-tuning -o jsonpath='{.spec.hard.requests\.memory}' 2>/dev/null)
POD=$(kubectl get resourcequota compute-quota -n resource-tuning -o jsonpath='{.spec.hard.pods}' 2>/dev/null)
case "$CPU" in
  1|1000m) ;;
  *) echo "quota requests.cpu is '${CPU:-none}', expected 1"; exit 1;;
esac
case "$MEM" in
  2Gi|2048Mi) ;;
  *) echo "quota requests.memory is '${MEM:-none}', expected 2Gi"; exit 1;;
esac
if [ "$POD" != "10" ]; then
  echo "quota pods is '${POD:-none}', expected 10"
  exit 1
fi
echo "ResourceQuota compute-quota is unchanged"
exit 0
