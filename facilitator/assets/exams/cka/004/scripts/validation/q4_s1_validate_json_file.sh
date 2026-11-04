#!/bin/bash
FILE=/tmp/exam/outputs/nodes-z3444kd9.json
if [ ! -s "$FILE" ]; then
  echo "File $FILE does not exist or is empty"; exit 1
fi
if ! python3 -c "import json,sys; d=json.load(open('$FILE')); sys.exit(0 if isinstance(d.get('items'), list) else 1)" 2>/dev/null; then
  echo "File is not valid JSON with an 'items' array"; exit 1
fi
echo "File exists and is a valid node list JSON"; exit 0
