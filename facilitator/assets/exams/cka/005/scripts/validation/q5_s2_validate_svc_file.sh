#!/bin/bash
FILE=/tmp/exam/nginx.svc
if [ ! -s "$FILE" ]; then echo "File $FILE missing or empty"; exit 1; fi
IP=$(kubectl get svc nginx-resolver-service -n default -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
if [ -z "$IP" ]; then echo "Cannot determine service ClusterIP"; exit 1; fi
grep -q "$IP" "$FILE" || { echo "File does not contain the service ClusterIP $IP"; exit 1; }
echo "File contains the service ClusterIP"; exit 0
