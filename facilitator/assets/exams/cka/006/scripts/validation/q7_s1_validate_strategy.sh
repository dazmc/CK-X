#!/bin/bash
T=$(kubectl get deploy webapp -n rollout-ex06 -o jsonpath='{.spec.strategy.type}' 2>/dev/null)
S=$(kubectl get deploy webapp -n rollout-ex06 -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)
U=$(kubectl get deploy webapp -n rollout-ex06 -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null)
R=$(kubectl get deploy webapp -n rollout-ex06 -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$T" != "RollingUpdate" ]; then
  echo "strategy type is '${T:-none}', expected RollingUpdate"
  exit 1
fi
if [ "$S" != "1" ]; then
  echo "maxSurge is '${S:-none}', expected 1"
  exit 1
fi
if [ "$U" != "0" ]; then
  echo "maxUnavailable is '${U:-none}', expected 0"
  exit 1
fi
if [ "$R" != "3" ]; then
  echo "replicas is '${R:-none}', expected 3"
  exit 1
fi
echo "RollingUpdate maxSurge=1 maxUnavailable=0 with 3 replicas"
exit 0
