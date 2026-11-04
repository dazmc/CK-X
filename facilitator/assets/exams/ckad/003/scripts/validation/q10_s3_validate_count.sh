#!/bin/bash
FILE=/tmp/exam/dind-878516_logs.txt
if [ ! -s "$FILE" ]; then echo "File $FILE missing or empty"; exit 1; fi
FILE_LINES=$(wc -l < "$FILE")
LOG_WARNINGS=$(kubectl logs dev-pod-dind-878516 -n default 2>/dev/null | grep -c "WARNING" || true)
if [ "$FILE_LINES" -lt 1 ]; then echo "File has no lines"; exit 1; fi
if [ "$FILE_LINES" -gt "$LOG_WARNINGS" ]; then
  echo "File has $FILE_LINES lines but container logs only contain $LOG_WARNINGS WARNING lines"; exit 1
fi
echo "File has $FILE_LINES lines (logs contain $LOG_WARNINGS WARNING lines)"; exit 0
