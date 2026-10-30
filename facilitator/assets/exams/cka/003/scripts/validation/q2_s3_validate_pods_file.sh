#!/bin/bash
# Validate /tmp/exam/running-pods.txt lists the running pod names
STATUS=0
for POD in $(kubectl get pods -n pod-basics -l app=web --field-selector=status.phase=Running -o name | sed 's|pod/||'); do
    if ! grep -q "$POD" /tmp/exam/running-pods.txt 2>/dev/null; then
        echo "❌ Running pod '$POD' not listed in /tmp/exam/running-pods.txt"
        STATUS=1
    fi
done
if [ ! -s /tmp/exam/running-pods.txt ] 2>/dev/null; then
    echo "❌ /tmp/exam/running-pods.txt is missing or empty"
    STATUS=1
fi
[ $STATUS -eq 0 ] && echo "✅ /tmp/exam/running-pods.txt lists all running pods"
exit $STATUS
