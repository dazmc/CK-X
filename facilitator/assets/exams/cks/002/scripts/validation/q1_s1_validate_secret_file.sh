#!/bin/bash
FILE=/tmp/exam/secrets/CONNECTOR_PASSWORD
if [ ! -s "$FILE" ]; then
  echo "File $FILE missing or empty"; exit 1
fi
EXPECTED=$(kubectl get secret a-safe-secret -n orion -o jsonpath='{.data.CONNECTOR_PASSWORD}' | base64 -d 2>/dev/null)
ACTUAL=$(cat "$FILE")
if [ -z "$EXPECTED" ]; then
  echo "Could not read the secret value from the cluster"; exit 1
fi
if [ "$ACTUAL" = "$EXPECTED" ]; then
  echo "File contains the decoded CONNECTOR_PASSWORD"; exit 0
fi
echo "File content does not match the decoded secret value"; exit 1
