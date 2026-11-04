#!/bin/bash
FILE=/tmp/exam/outputs/nodes_os_x43kj56.txt
if [ -s "$FILE" ]; then echo "File exists and is not empty"; exit 0; fi
echo "File $FILE does not exist or is empty"; exit 1
