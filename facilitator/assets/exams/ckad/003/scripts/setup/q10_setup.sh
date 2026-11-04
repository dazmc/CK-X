#!/bin/bash
# Setup for Question 10: pod whose logs contain WARNING lines
mkdir -p /tmp/exam
kubectl delete pod dev-pod-dind-878516 -n default --ignore-not-found --wait=true >/dev/null 2>&1
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: dev-pod-dind-878516
  namespace: default
  labels:
    run: dev-pod-dind-878516
spec:
  containers:
  - name: log-x
    image: busybox
    command:
    - /bin/sh
    - -c
    - "while true; do echo 'INFO: normal operation'; echo 'WARNING: disk usage is high'; sleep 5; done"
EOF
exit 0
