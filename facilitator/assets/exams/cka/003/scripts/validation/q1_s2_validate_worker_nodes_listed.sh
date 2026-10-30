#!/bin/bash
# Validate that every worker node in the cluster is listed in nodes.txt
MISSING=0
for NODE in $(kubectl get nodes -o name | sed 's|node/||' | grep -v "server-0$"); do
    if ! grep -q "$NODE" /tmp/exam/nodes.txt 2>/dev/null; then
        echo "❌ Worker node '$NODE' is not listed in /tmp/exam/nodes.txt"
        MISSING=1
    fi
done
if [ $MISSING -ne 0 ]; then
    exit 1
fi
echo "✅ All worker nodes are listed in /tmp/exam/nodes.txt"
exit 0
