#!/bin/bash
# Setup for Question 10: NetworkPolicy blocking traffic
kubectl create namespace netpol-debug --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f - <<'EOF2'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: netpol-debug
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
        ports:
        - containerPort: 80
EOF2

# Service so the tester pod has something to reach (cluster DNS name 'backend')
kubectl apply -f - <<'EOF2'
apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: netpol-debug
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 80
EOF2

# Policy intent: allow traffic to backend ONLY from pods labeled access=granted.
# It is misconfigured: the podSelector matches app=frontend (which no pod has),
# so nothing can reach the backend. The student must fix it.
kubectl apply -f - <<'EOF2'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-access
  namespace: netpol-debug
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - port: 80
EOF2

# Client pod labeled access=granted used by the student to test connectivity
kubectl apply -f - <<'EOF2'
apiVersion: v1
kind: Pod
metadata:
  name: tester
  namespace: netpol-debug
  labels:
    access: granted
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "3600"]
EOF2
exit 0
