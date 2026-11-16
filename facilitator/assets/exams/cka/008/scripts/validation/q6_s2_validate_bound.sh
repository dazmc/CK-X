#!/bin/bash
PH=$(kubectl get pvc dynamic-pvc -n dynamic-storage -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$PH" != "Bound" ]; then
  echo "PVC phase is '${PH:-none}', expected Bound"
  exit 1
fi
VN=$(kubectl get pvc dynamic-pvc -n dynamic-storage -o jsonpath='{.spec.volumeName}' 2>/dev/null)
if [ -z "$VN" ]; then
  echo "PVC has no bound volume"
  exit 1
fi
PROV=$(kubectl get pv "$VN" -o json 2>/dev/null | jq -r '.metadata.annotations["pv.kubernetes.io/provisioned-by"] // "missing"')
if [ "$PROV" = "missing" ] || [ -z "$PROV" ]; then
  echo "volume $VN lacks the dynamic-provisioning annotation - it must be provisioned by the default StorageClass, not hand-created"
  exit 1
fi
echo "PVC Bound to dynamically provisioned volume $VN (by $PROV)"
exit 0
