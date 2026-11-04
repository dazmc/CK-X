#!/bin/bash
DEP=nginx-deploy
IMG=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
AVAIL=$(kubectl get deployment $DEP -n default -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
[ "$IMG" = "nginx:1.16" ] || { echo "Deployment image is '$IMG', expected nginx:1.16 (rolled back)"; exit 1; }
[ "$AVAIL" = "4" ] || { echo "availableReplicas is '${AVAIL:-0}', expected 4"; exit 1; }
BAD=$(kubectl get pods -n default -l app=nginx-deploy -o jsonpath='{range .items[*]}{.spec.containers[0].image}{"\n"}{end}' 2>/dev/null | grep -cv '^nginx:1.16$' || true)
[ "$BAD" -eq 0 ] || { echo "$BAD pod(s) do not run nginx:1.16"; exit 1; }
echo "Rolled back to nginx:1.16 with 4 available pods"; exit 0
