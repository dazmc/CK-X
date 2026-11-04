#!/bin/bash
if KUBECONFIG=/tmp/exam/super.kubeconfig kubectl get nodes >/dev/null 2>&1; then
  echo "kubectl with super.kubeconfig succeeds"; exit 0
fi
echo "kubectl --kubeconfig=/tmp/exam/super.kubeconfig get nodes failed"; exit 1
