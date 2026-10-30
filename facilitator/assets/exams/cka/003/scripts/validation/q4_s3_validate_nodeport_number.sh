#!/bin/bash
# Validate the NodePort is 30088
NODEPORT=$(kubectl get svc web-svc -n nodeport-lab -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
if [ "$NODEPORT" != "30088" ]; then
    echo "❌ Service web-svc should use NodePort 30088 (found: '${NODEPORT:-none}')"
    exit 1
fi
echo "✅ Service web-svc uses NodePort 30088"
exit 0
