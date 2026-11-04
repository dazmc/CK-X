#!/bin/bash
FILE=/tmp/exam/nginx.pod
if [ ! -s "$FILE" ]; then echo "File $FILE missing or empty"; exit 1; fi
IP=$(kubectl get pod nginx-resolver -n default -o jsonpath='{.status.podIP}' 2>/dev/null)
if [ -z "$IP" ]; then echo "Cannot determine pod IP"; exit 1; fi
grep -q "$IP" "$FILE" || { echo "File does not contain the pod IP $IP"; exit 1; }
echo "File contains the pod IP"; exit 0
