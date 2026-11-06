#!/bin/bash
# Setup for Question 5: WaitForFirstConsumer storage namespace
# (source: theplatformlab exercise 25)
kubectl create namespace wffc-ex25 --dry-run=client -o yaml | kubectl apply -f -
exit 0
