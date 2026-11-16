#!/bin/bash
# Setup for Question 9: pod Pending on an unsatisfiable nodeSelector; record its
# identity so validation proves the pod was never recreated
# (source: techiescamp Q27)
kubectl create namespace pending-lab --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: pending-pod
  namespace: pending-lab
spec:
  nodeSelector:
    workload: batch
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "sleep 4800"]
EOF
mkdir -p /tmp/exam
POD_UID=""
for i in $(seq 1 30); do
  POD_UID=$(kubectl get pod pending-pod -n pending-lab -o jsonpath='{.metadata.uid}' 2>/dev/null)
  [ -n "$POD_UID" ] && break
  sleep 1
done
echo "$POD_UID" > /tmp/exam/pending_pod_uid.txt
exit 0
