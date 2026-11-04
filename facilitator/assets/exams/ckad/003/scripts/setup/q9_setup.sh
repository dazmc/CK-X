#!/bin/bash
# Setup for Question 9: backend services (and pods) pre-created
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: video-service
  namespace: default
spec:
  selector:
    app: video
  ports:
  - port: 8080
    targetPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: apparels-service
  namespace: default
spec:
  selector:
    app: apparels
  ports:
  - port: 8080
    targetPort: 80
EOF
exit 0
