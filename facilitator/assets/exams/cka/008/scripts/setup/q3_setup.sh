#!/bin/bash
# Setup for Question 3: a prepared Kustomize base the candidate must APPLY
# (source: techiescamp Q5 - apply an existing kustomization directory)
kubectl create namespace kustomize-demo --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /tmp/exam/kustomize/base
cat > /tmp/exam/kustomize/base/kustomization.yaml <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: kustomize-demo
resources:
  - deployment.yaml
  - service.yaml
labels:
  - pairs:
      app.kubernetes.io/managed-by: kustomize
EOF
cat > /tmp/exam/kustomize/base/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          ports:
            - containerPort: 80
EOF
cat > /tmp/exam/kustomize/base/service.yaml <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: webapp
spec:
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 80
EOF
exit 0
