#!/bin/bash
P=$(kubectl get sc local-wffc -o jsonpath='{.provisioner}' 2>/dev/null)
B=$(kubectl get sc local-wffc -o jsonpath='{.volumeBindingMode}' 2>/dev/null)
if [ "$P" != "rancher.io/local-path" ]; then
  echo "provisioner is '${P:-none}', expected rancher.io/local-path"
  exit 1
fi
if [ "$B" != "WaitForFirstConsumer" ]; then
  echo "volumeBindingMode is '${B:-none}', expected WaitForFirstConsumer"
  exit 1
fi
echo "StorageClass local-wffc uses rancher.io/local-path with WaitForFirstConsumer"
exit 0
