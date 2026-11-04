#!/bin/bash
FILE=/tmp/exam/outputs/nodes-z3444kd9.json
if [ ! -s "$FILE" ]; then
  echo "File $FILE missing"; exit 1
fi
MISSING=0
for n in $(kubectl get nodes -o name | cut -d/ -f2); do
  if ! grep -q "$n" "$FILE"; then
    echo "Node $n missing from file"
    MISSING=1
  fi
done
[ $MISSING -eq 0 ] || exit 1
echo "All nodes present in file"; exit 0
