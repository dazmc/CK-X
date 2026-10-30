#!/bin/bash
# Validate the CSR has an Approved condition
CONDITIONS=$(kubectl get csr app-web-csr -o jsonpath='{.status.conditions[*].type}' 2>/dev/null)
if ! echo "$CONDITIONS" | grep -q "Approved"; then
    echo "❌ CSR app-web-csr is not Approved (conditions: '${CONDITIONS:-none}')"
    exit 1
fi
echo "✅ CSR app-web-csr is Approved"
exit 0
