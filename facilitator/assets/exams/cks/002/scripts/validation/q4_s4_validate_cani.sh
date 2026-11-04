#!/bin/bash
A=$(kubectl auth can-i create pods -n dev-z --as=martin 2>/dev/null)
if [ "$A" != "no" ]; then echo "martin can still create pods in dev-z (answer: $A)"; exit 1; fi
B=$(kubectl auth can-i list pods -n dev-z --as=martin 2>/dev/null)
if [ "$B" != "yes" ]; then echo "martin can no longer list pods in dev-z (answer: $B)"; exit 1; fi
C=$(kubectl auth can-i delete pods -n dev-a --as=martin 2>/dev/null)
if [ "$C" != "yes" ]; then echo "martin lost full access in dev-a (answer: $C)"; exit 1; fi
echo "martin's permissions are correct in dev-z and dev-a"; exit 0
