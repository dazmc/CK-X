#!/bin/bash
# Validate the CSR was not Denied
CONDITIONS=$(kubectl get csr app-web-csr -o jsonpath='{.status.conditions[*].type}' 2>/dev/null)
if echo "$CONDITIONS" | grep -q "Denied"; then
    echo "❌ CSR app-web-csr was Denied instead of Approved"
    exit 1
fi
echo "✅ CSR app-web-csr was not Denied"
exit 0
