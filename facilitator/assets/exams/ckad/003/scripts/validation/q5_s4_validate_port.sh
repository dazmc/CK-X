#!/bin/bash
CP=$(kubectl get deployment redis -n default -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}' 2>/dev/null)
if [ "$CP" = "6379" ]; then echo "containerPort is 6379"; exit 0; fi
echo "containerPort is '${CP:-none}', expected 6379"; exit 1
