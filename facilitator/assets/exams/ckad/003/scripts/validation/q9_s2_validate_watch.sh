#!/bin/bash
IG=ingress-vh-routing
HOST=$(kubectl get ingress $IG -n default -o jsonpath='{.spec.rules[?(@.host=="watch.ecom-store.com")].http.paths[0].path}' 2>/dev/null)
SVC=$(kubectl get ingress $IG -n default -o jsonpath='{.spec.rules[?(@.host=="watch.ecom-store.com")].http.paths[0].backend.service.name}' 2>/dev/null)
PORT=$(kubectl get ingress $IG -n default -o jsonpath='{.spec.rules[?(@.host=="watch.ecom-store.com")].http.paths[0].backend.service.port.number}' 2>/dev/null)
[ "$HOST" = "/video" ] || { echo "Path for watch.ecom-store.com is '${HOST:-none}', expected /video"; exit 1; }
[ "$SVC" = "video-service" ] || { echo "Backend is '${SVC:-none}', expected video-service"; exit 1; }
[ "$PORT" = "8080" ] || { echo "Backend port is '${PORT:-none}', expected 8080"; exit 1; }
echo "watch.ecom-store.com/video -> video-service:8080"; exit 0
