#!/bin/bash
# Validate CSR app-web-csr exists
kubectl get csr app-web-csr &>/dev/null || {
    echo "❌ CertificateSigningRequest app-web-csr not found"
    exit 1
}
echo "✅ CertificateSigningRequest app-web-csr exists"
exit 0
