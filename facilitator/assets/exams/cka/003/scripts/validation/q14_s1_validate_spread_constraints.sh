#!/bin/bash
# Validate deployment has a topologySpreadConstraints entry on hostname
COUNT=$(kubectl get deployment spread-app -n spread -o jsonpath='{.spec.template.spec.topologySpreadConstraints[*].topologyKey}' 2>/dev/null | wc -w)
if [ "$COUNT" -lt 1 ]; then
    echo "❌ Deployment spread-app has no topologySpreadConstraints"
    exit 1
fi
KEY=$(kubectl get deployment spread-app -n spread -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].topologyKey}' 2>/dev/null)
if [ "$KEY" != "kubernetes.io/hostname" ]; then
    echo "❌ topologyKey should be kubernetes.io/hostname (found: $KEY)"
    exit 1
fi
MAXSKEW=$(kubectl get deployment spread-app -n spread -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].maxSkew}' 2>/dev/null)
if [ "$MAXSKEW" != "1" ]; then
    echo "❌ maxSkew should be 1 (found: ${MAXSKEW:-none})"
    exit 1
fi
WHEN=$(kubectl get deployment spread-app -n spread -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].whenUnsatisfiable}' 2>/dev/null)
if [ "$WHEN" != "DoNotSchedule" ]; then
    echo "❌ whenUnsatisfiable should be DoNotSchedule (found: ${WHEN:-none})"
    exit 1
fi
echo "✅ topologySpreadConstraints configured correctly"
exit 0
