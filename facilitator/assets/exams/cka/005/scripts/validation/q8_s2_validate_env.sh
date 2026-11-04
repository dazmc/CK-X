#!/bin/bash
A_NAME=$(kubectl get pod multi-pod -n default -o jsonpath='{.spec.containers[?(@.name=="alpha")].env[?(@.name=="name")].value}' 2>/dev/null)
A_IMG=$(kubectl get pod multi-pod -n default -o jsonpath='{.spec.containers[?(@.name=="alpha")].image}' 2>/dev/null)
B_NAME=$(kubectl get pod multi-pod -n default -o jsonpath='{.spec.containers[?(@.name=="beta")].env[?(@.name=="name")].value}' 2>/dev/null)
B_CMD=$(kubectl get pod multi-pod -n default -o jsonpath='{.spec.containers[?(@.name=="beta")].command[*]}' 2>/dev/null)
[ "$A_IMG" = "nginx" ] || { echo "alpha image is '$A_IMG', expected nginx"; exit 1; }
[ "$A_NAME" = "alpha" ] || { echo "alpha env name='$A_NAME', expected alpha"; exit 1; }
[ "$B_NAME" = "beta" ] || { echo "beta env name='$B_NAME', expected beta"; exit 1; }
echo "$B_CMD" | grep -q "sleep" || { echo "beta command missing sleep: '$B_CMD'"; exit 1; }
echo "$B_CMD" | grep -q "4800" || { echo "beta command missing 4800: '$B_CMD'"; exit 1; }
echo "Environment variables and commands correct"; exit 0
