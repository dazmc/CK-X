#!/bin/bash
FILE=/tmp/exam/outputs/nodes_os_x43kj56.txt
if [ ! -s "$FILE" ]; then echo "File $FILE missing"; exit 1; fi
EXPECTED=$(kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' | wc -w)
ACTUAL=$(wc -w < "$FILE")
if [ "$ACTUAL" -ne "$EXPECTED" ]; then
  echo "File has $ACTUAL entries, expected one per node ($EXPECTED)"; exit 1
fi
for os in $(kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' | tr ' ' '\n' | sort -u); do
  grep -q "$os" "$FILE" || { echo "osImage '$os' missing from file"; exit 1; }
done
echo "One osImage entry per node"; exit 0
