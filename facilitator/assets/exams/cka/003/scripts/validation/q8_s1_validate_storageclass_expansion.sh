#!/bin/bash
# Validate the StorageClass allows volume expansion
ALLOWED=$(kubectl get storageclass expandable -o jsonpath='{.allowVolumeExpansion}' 2>/dev/null)
if [ "$ALLOWED" != "true" ]; then
    echo "❌ StorageClass expandable does not have allowVolumeExpansion: true (found: '${ALLOWED:-none}')"
    exit 1
fi
echo "✅ StorageClass expandable allows volume expansion"
exit 0
