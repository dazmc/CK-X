#!/bin/bash
DEF=$(kubectl get storageclass -o json 2>/dev/null | jq -r '[.items[] | select(.metadata.annotations["storageclass.kubernetes.io/is-default-class"]=="true") | .metadata.name] | first // ""')
if [ -z "$DEF" ]; then
  echo "cluster has no default StorageClass - cannot validate"
  exit 1
fi
J=$(kubectl get pvc dynamic-pvc -n dynamic-storage -o json 2>/dev/null) || { echo "PVC dynamic-pvc not found in dynamic-storage"; exit 1; }
SC=$(echo "$J" | jq -r '.spec.storageClassName // "none"')
SZ=$(echo "$J" | jq -r '.spec.resources.requests.storage')
AM=$(echo "$J" | jq -r '.spec.accessModes[0] // "missing"')
if [ "$SC" != "$DEF" ]; then
  echo "storageClassName is '$SC', expected the default StorageClass '$DEF'"
  exit 1
fi
case "$SZ" in
  1Gi|1024Mi) ;;
  *) echo "PVC size is '$SZ', expected 1Gi"; exit 1;;
esac
if [ "$AM" != "ReadWriteOnce" ]; then
  echo "accessMode is '$AM', expected ReadWriteOnce"
  exit 1
fi
echo "PVC dynamic-pvc: 1Gi ReadWriteOnce on default StorageClass ($DEF)"
exit 0
