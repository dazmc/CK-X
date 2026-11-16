#!/bin/bash
# Setup for Question 10: two-container pod; app writes 150 stable lines, sidecar emits
# noise so `kubectl logs` without -c grabs the wrong thing
# (source: techiescamp Q32)
kubectl create namespace logs --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /tmp/exam/outputs
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: multi-app
  namespace: logs
spec:
  containers:
    - name: app
      image: busybox:1.36
      command:
        - sh
        - -c
        - 'i=1; while [ "$i" -le 150 ]; do echo "app-line-$i"; i=$((i+1)); done; sleep 99999'
    - name: sidecar
      image: busybox:1.36
      command: ["sh", "-c", "while true; do echo sidecar-noise; sleep 1; done"]
EOF
# wait for Running, then let the app finish writing its 150 lines
for i in $(seq 1 60); do
  PH=$(kubectl get pod multi-app -n logs -o jsonpath='{.status.phase}' 2>/dev/null)
  [ "$PH" = "Running" ] && break
  sleep 2
done
sleep 3
exit 0
