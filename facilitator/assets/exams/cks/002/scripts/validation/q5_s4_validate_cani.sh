#!/bin/bash
A=$(kubectl auth can-i create pods -n dev --as=system:serviceaccount:dev:developer 2>/dev/null)
if [ "$A" = "yes" ]; then
  echo "developer ServiceAccount can create pods in dev"; exit 0
fi
echo "developer ServiceAccount cannot create pods in dev (answer: $A)"; exit 1
