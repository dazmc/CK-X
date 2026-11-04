#!/bin/bash
DEP=hr-web-app
SEL=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.selector.matchLabels.app}' 2>/dev/null)
TPL=$(kubectl get deployment $DEP -n default -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
if [ "$SEL" != "hr-web-app" ]; then echo "Selector app='${SEL:-none}', expected hr-web-app"; exit 1; fi
if [ "$TPL" != "hr-web-app" ]; then echo "Template label app='${TPL:-none}', expected hr-web-app"; exit 1; fi
echo "Selector and template labels match"; exit 0
