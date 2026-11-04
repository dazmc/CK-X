#!/bin/bash
FILE=/etc/kubernetes/manifests/static-busybox.yaml
if [ ! -s "$FILE" ]; then echo "File $FILE missing"; exit 1; fi
grep -q "kind: *Pod" "$FILE" || { echo "Not a Pod manifest"; exit 1; }
grep -q "name: *static-busybox" "$FILE" || { echo "Pod name is not static-busybox"; exit 1; }
grep -q "image: *busybox" "$FILE" || { echo "Image is not busybox"; exit 1; }
grep -q "run: *static-busybox" "$FILE" || { echo "Label run=static-busybox missing"; exit 1; }
grep -q "sleep" "$FILE" || { echo "Command does not contain sleep"; exit 1; }
grep -q "sleeeep" "$FILE" && { echo "Command still contains the sleeeep typo"; exit 1; }
echo "Manifest content is correct"; exit 0
