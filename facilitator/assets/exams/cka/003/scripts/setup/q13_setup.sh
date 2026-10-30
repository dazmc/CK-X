#!/bin/bash
# Setup for Question 13: RBAC 403 troubleshooting
# A service account can list pods but gets 403 when reading configmaps.
# The student must find and grant the missing permission.
kubectl create namespace rbac-debug --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'EOF2'
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pod-viewer
  namespace: rbac-debug
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-inspector
  namespace: rbac-debug
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-viewer-binding
  namespace: rbac-debug
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pod-inspector
subjects:
- kind: ServiceAccount
  name: pod-viewer
  namespace: rbac-debug
EOF2

# Some pods and a configmap for the SA to work with
kubectl apply -f - <<'EOF2'
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-settings
  namespace: rbac-debug
data:
  mode: "production"
---
apiVersion: v1
kind: Pod
metadata:
  name: workload-1
  namespace: rbac-debug
  labels:
    app: workload
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
EOF2
exit 0
