#!/bin/bash
FILE=/tmp/exam/dind-878516_logs.txt
if [ ! -s "$FILE" ]; then echo "File $FILE missing or empty"; exit 1; fi
BAD=$(grep -cv "WARNING" "$FILE" || true)
if [ "$BAD" -eq 0 ]; then
  echo "Every line contains WARNING"; exit 0
fi
echo "$BAD line(s) in the file do not contain WARNING"; exit 1
