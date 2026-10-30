#!/bin/bash
# Validate the fix was scoped: SA must NOT have cluster-wide or other-namespace access
ANSWER=$(kubectl auth can-i get configmaps -n kube-system --as=system:serviceaccount:rbac-debug:pod-viewer 2>/dev/null)
if [ "$ANSWER" == "yes" ]; then
    echo "❌ Fix is too broad: pod-viewer can read configmaps outside its namespace"
    exit 1
fi
ANSWER2=$(kubectl auth can-i create pods --all-namespaces --as=system:serviceaccount:rbac-debug:pod-viewer 2>/dev/null)
if [ "$ANSWER2" == "yes" ]; then
    echo "❌ Fix is too broad: pod-viewer has cluster-wide pod creation rights"
    exit 1
fi
echo "✅ RBAC fix is correctly scoped to the namespace"
exit 0
