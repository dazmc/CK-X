#!/bin/bash
REVS=$(kubectl rollout history deployment frontend -n ckad-rollout 2>/dev/null | awk 'NR>1 && $1 ~ /^[0-9]+$/' | wc -l)
if [ "$REVS" -ge 2 ]; then
  echo "Rollout history has $REVS revisions"; exit 0
fi
echo "Rollout history has $REVS revision(s), expected at least 2 (evidence of the image update)"; exit 1
