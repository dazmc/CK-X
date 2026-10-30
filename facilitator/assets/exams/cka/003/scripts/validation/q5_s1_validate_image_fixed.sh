#!/bin/bash
# Validate the deployment image has been corrected
IMAGE=$(kubectl get deployment web-recovery -n image-fix -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$IMAGE" == "nginx:1.25.12-typo" ]; then
    echo "❌ Deployment still uses the broken image nginx:1.25.12-typo"
    exit 1
fi
echo "✅ Deployment image corrected (now: $IMAGE)"
exit 0
