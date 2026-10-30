#!/bin/bash
# Validate the root cause was fixed: the settings file exists in the app container
kubectl exec app-crasher -n debug-pod -- test -f /app/config/settings.conf >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ /app/config/settings.conf still does not exist in the app container"
    exit 1
fi
echo "✅ /app/config/settings.conf exists in the app container"
exit 0
