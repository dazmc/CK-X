#!/bin/bash
# Setup for Question 6: drain lab - a completed Job with emptyDir data pinned to the node
# that must be drained; the Job pod is controller-managed (normal drain flags apply) and is
# never recreated once evicted, so the drain is verifiable
# (source: theplatformlab exercise 08)
kubectl create namespace drain-ex08 --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: drain-demo
  namespace: drain-ex08
spec:
  replicas: 2
  selector:
    matchLabels:
      app: drain-demo
  template:
    metadata:
      labels:
        app: drain-demo
    spec:
      containers:
        - name: nginx
          image: nginx:1.27
          ports:
            - containerPort: 80
---
apiVersion: batch/v1
kind: Job
metadata:
  name: drain-marker
  namespace: drain-ex08
spec:
  template:
    spec:
      restartPolicy: Never
      nodeSelector:
        kubernetes.io/hostname: k3d-cluster-agent-1
      containers:
        - name: marker
          image: busybox:1.36
          command: ["sh", "-c", "sleep 30"]
          volumeMounts:
            - name: local-data
              mountPath: /data
      volumes:
        - name: local-data
          emptyDir: {}
EOF
exit 0
