#!/bin/bash
EN=$(kubectl get pod time-check -n dvl1987 -o jsonpath='{.spec.containers[0].env[?(@.name=="TIME_FREQ")].valueFrom.configMapKeyRef.name}' 2>/dev/null)
EK=$(kubectl get pod time-check -n dvl1987 -o jsonpath='{.spec.containers[0].env[?(@.name=="TIME_FREQ")].valueFrom.configMapKeyRef.key}' 2>/dev/null)
EV=$(kubectl get pod time-check -n dvl1987 -o jsonpath='{.spec.containers[0].env[?(@.name=="TIME_FREQ")].value}' 2>/dev/null)
[ -z "$EV" ] || { echo "TIME_FREQ has a hardcoded value '$EV', expected valueFrom configMapKeyRef"; exit 1; }
[ "$EN" = "time-config" ] || { echo "configMap name is '${EN:-none}', expected time-config"; exit 1; }
[ "$EK" = "TIME_FREQ" ] || { echo "configMap key is '${EK:-none}', expected TIME_FREQ"; exit 1; }
echo "TIME_FREQ sourced from ConfigMap time-config"; exit 0
