#!/bin/bash
F=/tmp/exam/outputs/multi-app-logs.txt
if [ ! -f "$F" ]; then
  echo "output file $F does not exist"
  exit 1
fi
N=$(awk 'END{print NR}' "$F")
if [ "$N" != "100" ]; then
  echo "file has $N lines, expected exactly 100 (the LAST 100 lines: kubectl logs -c app --tail=100)"
  exit 1
fi
echo "File has exactly 100 lines"
exit 0
