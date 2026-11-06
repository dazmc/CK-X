#!/bin/bash
C=$(kubectl get deployment toolbox -n ckad-security -o jsonpath='{.spec.template.spec.containers[0].securityContext.capabilities.add[*]}' 2>/dev/null)
echo "$C" | grep -qw "NET_ADMIN" || { echo "capabilities missing NET_ADMIN (have: '${C:-none}')"; exit 1; }
echo "$C" | grep -qw "SYS_TIME" || { echo "capabilities missing SYS_TIME (have: '${C:-none}')"; exit 1; }
echo "Capabilities add NET_ADMIN and SYS_TIME"; exit 0
