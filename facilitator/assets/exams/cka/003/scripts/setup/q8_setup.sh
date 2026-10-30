#!/bin/bash
# Setup for Question 8: PVC expansion
kubectl create namespace storage-expand --dry-run=client -o yaml | kubectl apply -f -

# Note: allowVolumeExpansion is intentionally NOT set here - the student must enable it.
kubectl apply -f - <<'EOF2'
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: expandable
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
EOF2

kubectl apply -f - <<'EOF2'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
  namespace: storage-expand
spec:
  storageClassName: expandable
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
EOF2

# Consumer pod: with WaitForFirstConsumer the claim only binds once a pod
# uses it. This pod keeps the claim Bound so it can be expanded in place.
kubectl apply -f - <<'EOF2'
apiVersion: v1
kind: Pod
metadata:
  name: data-pod
  namespace: storage-expand
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: data-pvc
EOF2
exit 0
