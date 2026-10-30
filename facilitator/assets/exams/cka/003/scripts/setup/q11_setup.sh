#!/bin/bash
# Setup for Question 11: Pod never Ready - investigated with kubectl debug
# The container stays alive (so it can be debugged/attached to), but its
# readiness probe fails until /app/config/settings.conf exists.
kubectl create namespace debug-pod --dry-run=client -o yaml | kubectl apply -f -

kubectl delete pod app-crasher -n debug-pod --grace-period=0 --force 2>/dev/null || true

kubectl apply -f - <<'EOF2'
apiVersion: v1
kind: Pod
metadata:
  name: app-crasher
  namespace: debug-pod
spec:
  restartPolicy: Always
  volumes:
  - name: appconfig
    emptyDir: {}
  containers:
  - name: app
    image: busybox:1.36
    command:
    - sh
    - -c
    - |
      if [ ! -f /app/config/settings.conf ]; then
        echo "ERROR: missing /app/config/settings.conf - waiting for config"
      fi
      while [ ! -f /app/config/settings.conf ]; do sleep 5; done
      echo "config found - app started"
      sleep 3600
    volumeMounts:
    - name: appconfig
      mountPath: /app/config
    readinessProbe:
      exec:
        command: ["test", "-f", "/app/config/settings.conf"]
      initialDelaySeconds: 2
      periodSeconds: 5
EOF2
exit 0
