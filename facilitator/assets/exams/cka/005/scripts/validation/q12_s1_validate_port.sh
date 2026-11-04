#!/bin/bash
FILE=/tmp/exam/super.kubeconfig
if [ ! -s "$FILE" ]; then echo "File $FILE missing"; exit 1; fi
if grep -q ":2379" "$FILE"; then
  echo "File still points at port 2379"; exit 1
fi
if ! grep -q ":6443" "$FILE"; then
  echo "File does not contain an API server URL on port 6443"; exit 1
fi
echo "API server port corrected to 6443"; exit 0
