#!/bin/bash
FILE=/tmp/exam/node_ips
if [ ! -s "$FILE" ]; then echo "File $FILE missing"; exit 1; fi
MISSING=0
for ip in $(kubectl get nodes -o jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}'); do
  grep -q "$ip" "$FILE" || { echo "Node InternalIP $ip missing from file"; MISSING=1; }
done
[ $MISSING -eq 0 ] || exit 1
echo "All node InternalIPs present"; exit 0
