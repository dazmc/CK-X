#!/bin/bash
FILE=/tmp/exam/node_ips
if [ -s "$FILE" ]; then echo "File exists and is not empty"; exit 0; fi
echo "File $FILE missing or empty"; exit 1
