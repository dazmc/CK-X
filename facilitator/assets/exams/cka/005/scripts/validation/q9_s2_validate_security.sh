#!/bin/bash
UID_=$(kubectl get pod non-root-pod -n default -o jsonpath='{.spec.securityContext.runAsUser}' 2>/dev/null)
FS=$(kubectl get pod non-root-pod -n default -o jsonpath='{.spec.securityContext.fsGroup}' 2>/dev/null)
[ "$UID_" = "1000" ] || { echo "runAsUser is '${UID_:-none}', expected 1000 (pod-level securityContext)"; exit 1; }
[ "$FS" = "2000" ] || { echo "fsGroup is '${FS:-none}', expected 2000 (pod-level securityContext)"; exit 1; }
echo "runAsUser 1000 and fsGroup 2000 set at pod level"; exit 0
