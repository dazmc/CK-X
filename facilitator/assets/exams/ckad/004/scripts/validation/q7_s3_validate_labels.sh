#!/bin/bash
SL=$(kubectl get deployment storefront -n ckad-canary -o go-template='{{range $k,$v := .spec.template.metadata.labels}}{{$k}}={{$v}} {{end}}' 2>/dev/null)
CL=$(kubectl get deployment storefront-canary -n ckad-canary -o go-template='{{range $k,$v := .spec.template.metadata.labels}}{{$k}}={{$v}} {{end}}' 2>/dev/null)
SS=$(kubectl get deployment storefront -n ckad-canary -o go-template='{{range $k,$v := .spec.selector.matchLabels}}{{$k}}={{$v}} {{end}}' 2>/dev/null)
CS=$(kubectl get deployment storefront-canary -n ckad-canary -o go-template='{{range $k,$v := .spec.selector.matchLabels}}{{$k}}={{$v}} {{end}}' 2>/dev/null)
echo "$SL" | grep -q "app=storefront" || { echo "stable template missing app=storefront (has: $SL)"; exit 1; }
echo "$CL" | grep -q "app=storefront" || { echo "canary template missing app=storefront (has: $CL)"; exit 1; }
NSL=$(echo $SL | wc -w); NCL=$(echo $CL | wc -w)
[ "$NSL" -ge 2 ] || { echo "stable template has only $NSL label(s) - needs a distinguishing second label (has: $SL)"; exit 1; }
[ "$NCL" -ge 2 ] || { echo "canary template has only $NCL label(s) - needs a distinguishing second label (has: $CL)"; exit 1; }
[ "$SL" != "$CL" ] || { echo "both templates have identical labels - no distinguishing label ($SL)"; exit 1; }
[ "$SS" != "$CS" ] || { echo "both selectors are identical ($SS) - canary selector must include the distinguishing label"; exit 1; }
echo "Shared app=storefront with distinguishing labels: stable[$SL] canary[$CL]"; exit 0
