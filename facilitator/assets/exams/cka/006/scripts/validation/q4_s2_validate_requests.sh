#!/bin/bash
if ! kubectl get pods -n resource-tuning -l app=web -o json 2>/dev/null | jq -e '
    [.items[] | select(.status.phase=="Running") | .spec.containers[]] as $c |
    ($c | length) > 0 and
    all($c[];
      (((.resources.requests.cpu // "0") | gsub("m$";"") | tonumber) > 0) and
      (((.resources.requests.memory // "0") | sub("[GMi]+$";"") | tonumber) > 0))' >/dev/null; then
  echo "Every running container must declare positive requests.cpu and requests.memory"
  exit 1
fi
echo "All containers declare positive cpu and memory requests"
exit 0
