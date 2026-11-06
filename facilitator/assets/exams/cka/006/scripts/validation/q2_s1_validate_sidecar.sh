#!/bin/bash
D=logger; N=sidecar-ex02
IMG=$(kubectl get deploy $D -n $N -o jsonpath='{.spec.template.spec.initContainers[?(@.name=="log-agent")].image}' 2>/dev/null)
RP=$(kubectl get deploy $D -n $N -o jsonpath='{.spec.template.spec.initContainers[?(@.name=="log-agent")].restartPolicy}' 2>/dev/null)
if [ "$IMG" != "busybox:1.36" ]; then
  echo "log-agent image is '${IMG:-none}', expected busybox:1.36"
  exit 1
fi
if [ "$RP" != "Always" ]; then
  echo "log-agent restartPolicy is '${RP:-none}', expected Always (native sidecar)"
  exit 1
fi
echo "log-agent init container uses restartPolicy Always"
exit 0
