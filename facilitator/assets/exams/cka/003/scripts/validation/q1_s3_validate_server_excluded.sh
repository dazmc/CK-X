#!/bin/bash
# Validate that the control-plane (server) node is NOT listed in nodes.txt
if grep -q "server-0" /tmp/exam/nodes.txt 2>/dev/null; then
    echo "❌ Control-plane node should not be listed in /tmp/exam/nodes.txt"
    exit 1
fi
echo "✅ Control-plane node correctly excluded from /tmp/exam/nodes.txt"
exit 0
