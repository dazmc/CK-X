#!/bin/bash
U=$(kubectl get deployment toolbox -n ckad-security -o jsonpath='{.spec.template.spec.containers[0].securityContext.runAsUser}' 2>/dev/null)
if [ "$U" = "1000" ]; then echo "container runAsUser is 1000"; exit 0; fi
echo "runAsUser is '${U:-unset}', expected 1000 at container level"; exit 1
