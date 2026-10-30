#!/bin/bash
# Setup for Question 12: Deprecated API versions
# Student receives manifests using removed apiVersions and must convert + apply them
kubectl create namespace api-update --dry-run=client -o yaml | kubectl apply -f -

mkdir -p /tmp/exam/deprecations
rm -f /tmp/exam/deprecations/*.yaml

cat > /tmp/exam/deprecations/deployment.yaml <<'EOF2'
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: legacy-app
  namespace: api-update
spec:
  replicas: 2
  selector:
    matchLabels:
      app: legacy-app
  template:
    metadata:
      labels:
        app: legacy-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.27
EOF2

cat > /tmp/exam/deprecations/ingress.yaml <<'EOF2'
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: legacy-ingress
  namespace: api-update
spec:
  rules:
  - host: legacy.local
    http:
      paths:
      - path: /
        backend:
          serviceName: legacy-svc
          servicePort: 80
EOF2

cat > /tmp/exam/deprecations/cronjob.yaml <<'EOF2'
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: legacy-cron
  namespace: api-update
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox:1.36
            command: ["echo", "hello"]
          restartPolicy: OnFailure
EOF2

# A supporting service the ingress points to
kubectl apply -f - <<'EOF2'
apiVersion: v1
kind: Service
metadata:
  name: legacy-svc
  namespace: api-update
spec:
  selector:
    app: legacy-app
  ports:
  - port: 80
    targetPort: 80
EOF2
exit 0
