#!/bin/bash
# Setup for Question 3: LimitRange + provided pod manifest (from spudale lab 03)
kubectl create namespace ckad-pod-cpu --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-constraints
  namespace: ckad-pod-cpu
spec:
  limits:
    - type: Container
      max:
        cpu: "1"
EOF
mkdir -p /tmp/exam
cat > /tmp/exam/pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: worker
  namespace: ckad-pod-cpu
spec:
  containers:
    - name: worker
      image: busybox:1.36
      command: ["sh", "-c", "while true; do sleep 3600; done"]
      resources:
        requests:
          cpu: 200m
EOF
exit 0
