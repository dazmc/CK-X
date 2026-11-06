#!/bin/bash
# Setup for Question 8: cronjob namespace (source: theplatformlab exercise 21 + mock Q12)
kubectl create namespace cron-ex21 --dry-run=client -o yaml | kubectl apply -f -
exit 0
