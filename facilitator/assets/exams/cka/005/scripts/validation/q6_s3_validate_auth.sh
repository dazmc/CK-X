#!/bin/bash
ANS=$(kubectl auth can-i list persistentvolumes --as=system:serviceaccount:default:pvviewer 2>/dev/null)
if [ "$ANS" = "yes" ]; then
  echo "ServiceAccount can list persistentvolumes"; exit 0
fi
echo "Answer was '$ANS', expected yes"; exit 1
