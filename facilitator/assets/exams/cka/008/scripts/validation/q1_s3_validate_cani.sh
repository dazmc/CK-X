#!/bin/bash
A=$(kubectl auth can-i get pods -n rbac-test --as=alice 2>/dev/null)
B=$(kubectl auth can-i delete pods -n rbac-test --as=alice 2>/dev/null)
C=$(kubectl auth can-i get secrets -n rbac-test --as=alice 2>/dev/null)
D=$(kubectl auth can-i list pods -n default --as=alice 2>/dev/null)
E=$(kubectl auth can-i create pods -n rbac-test --as=alice 2>/dev/null)
if [ "$A" != "yes" ] || [ "$E" != "yes" ] || [ "$B" != "yes" ]; then
  echo "alice must be able to get/create/delete pods in rbac-test (got: get=$A create=$E delete=$B)"
  exit 1
fi
if [ "$C" != "no" ]; then
  echo "alice must NOT be able to get secrets in rbac-test (got: $C)"
  exit 1
fi
if [ "$D" != "no" ]; then
  echo "alice must NOT be able to list pods in namespace default (got: $D)"
  exit 1
fi
echo "Permissions for user alice are correctly scoped"
exit 0
