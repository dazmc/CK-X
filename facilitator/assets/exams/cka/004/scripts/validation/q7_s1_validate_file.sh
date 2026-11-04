#!/bin/bash
FILE=/etc/kubernetes/manifests/static-busybox.yaml
if [ -s "$FILE" ]; then echo "Manifest file exists"; exit 0; fi
echo "File $FILE does not exist or is empty"; exit 1
