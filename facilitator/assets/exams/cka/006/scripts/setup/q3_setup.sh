#!/bin/bash
# Setup for Question 3: ingress lab with two services and a TLS secret
# (source: theplatformlab exercise 19 + mock exam Q8)
kubectl create namespace ingress-ex19 --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: ingress-ex19
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
        - name: nginx
          image: nginx:1.28
          ports:
            - containerPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-app
  namespace: ingress-ex19
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api-app
  template:
    metadata:
      labels:
        app: api-app
    spec:
      containers:
        - name: nginx
          image: nginx:1.28
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: ingress-ex19
spec:
  selector:
    app: web-app
  ports:
    - port: 80
      targetPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: api-service
  namespace: ingress-ex19
spec:
  selector:
    app: api-app
  ports:
    - port: 8080
      targetPort: 80
---
apiVersion: v1
kind: Secret
metadata:
  name: api-tls-cert
  namespace: ingress-ex19
type: kubernetes.io/tls
stringData:
  tls.crt: dummy-cert
  tls.key: dummy-key
EOF
exit 0
