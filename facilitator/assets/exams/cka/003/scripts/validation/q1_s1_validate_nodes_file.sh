#!/bin/bash
# Validate that /tmp/exam/nodes.txt exists and is non-empty
if [ ! -f /tmp/exam/nodes.txt ]; then
    echo "❌ File /tmp/exam/nodes.txt not found"
    exit 1
fi
if [ ! -s /tmp/exam/nodes.txt ]; then
    echo "❌ File /tmp/exam/nodes.txt is empty"
    exit 1
fi
echo "✅ /tmp/exam/nodes.txt exists and is not empty"
exit 0
