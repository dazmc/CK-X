#!/bin/bash
# Setup for Question 2: broken-by-design secure-pod behind default-deny policy
kubectl delete networkpolicy allow-webapp-color -n default --ignore-not-found >/dev/null 2>&1
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress: []
---
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
  namespace: default
  labels:
    run: secure-pod
spec:
  containers:
  - name: secure-pod
    image: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: secure-service
  namespace: default
spec:
  selector:
    run: secure-pod
  ports:
  - port: 80
    targetPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: webapp-color
  namespace: default
  labels:
    run: webapp-color
    name: webapp-color
spec:
  containers:
  - name: webapp-color
    image: kodekloud/webapp-color
EOF
exit 0
