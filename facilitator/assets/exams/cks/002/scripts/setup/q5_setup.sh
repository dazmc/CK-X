#!/bin/bash
# Setup for Question 5: namespace + pod template
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /tmp/exam
cat > /tmp/exam/dev-pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: dev-pod
  namespace: dev
  labels:
    name: dev-pod
spec:
  containers:
  - name: dev-pod
    image: nginx
EOF
exit 0
