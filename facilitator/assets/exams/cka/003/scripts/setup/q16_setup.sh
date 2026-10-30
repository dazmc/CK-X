#!/bin/bash
# Setup for Question 16: Node maintenance recovery
# Node k3d-cluster-agent-1 was cordoned for maintenance and tainted.
# critical-app pods are stuck Pending; the student must restore service.
kubectl create namespace maintenance --dry-run=client -o yaml | kubectl apply -f -

kubectl uncordon k3d-cluster-agent-1 2>/dev/null || true
kubectl taint nodes k3d-cluster-agent-1 dedicated- 2>/dev/null || true

# Now apply the "maintenance" state
kubectl cordon k3d-cluster-agent-1
kubectl taint nodes k3d-cluster-agent-1 dedicated=critical:NoSchedule

kubectl apply -f - <<'EOF2'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: critical-app
  namespace: maintenance
spec:
  replicas: 3
  selector:
    matchLabels:
      app: critical-app
  template:
    metadata:
      labels:
        app: critical-app
    spec:
      nodeSelector:
        kubernetes.io/hostname: k3d-cluster-agent-1
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
EOF2
exit 0
