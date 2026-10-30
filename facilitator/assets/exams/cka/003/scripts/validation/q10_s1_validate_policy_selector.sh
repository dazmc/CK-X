#!/bin/bash
# Validate the policy now allows from pods labeled access=granted
FROM_ACCESS=$(kubectl get netpol backend-access -n netpol-debug -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.access}' 2>/dev/null)
FROM_APP=$(kubectl get netpol backend-access -n netpol-debug -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}' 2>/dev/null)
if [ "$FROM_ACCESS" == "granted" ]; then
    echo "✅ backend-access allows traffic from pods labeled access=granted"
    exit 0
fi
if [ "$FROM_APP" == "frontend" ]; then
    echo "❌ backend-access still selects app=frontend, which no pod has"
    exit 1
fi
echo "❌ backend-access does not allow from access=granted (access='${FROM_ACCESS:-none}', app='${FROM_APP:-none}')"
exit 1
