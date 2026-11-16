#!/bin/bash
F=/tmp/exam/outputs/multi-app-logs.txt
if [ ! -f "$F" ]; then
  echo "output file $F does not exist"
  exit 1
fi
EXPECT=$(for i in $(seq 51 150); do echo "app-line-$i"; done)
ACTUAL=$(cat "$F")
if [ "$ACTUAL" != "$EXPECT" ]; then
  echo "file does not contain the last 100 app log lines (app-line-51 .. app-line-150)"
  echo "--- first line: $(head -1 "$F")"
  echo "--- last line: $(tail -1 "$F")"
  exit 1
fi
echo "Content is app-line-51 through app-line-150 in order"
exit 0
