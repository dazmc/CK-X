#!/bin/bash
F=/tmp/exam/outputs/multi-app-logs.txt
if [ ! -f "$F" ]; then
  echo "output file $F does not exist"
  exit 1
fi
if grep -q "sidecar" "$F"; then
  echo "file contains sidecar container output - only the app container's logs belong here (use kubectl logs -c app)"
  exit 1
fi
echo "No sidecar output in the file"
exit 0
