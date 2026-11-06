#!/bin/bash
# Setup for Question 6: namespace only - the CronJob is the task (from spudale lab 06)
kubectl create namespace ckad-cron --dry-run=client -o yaml | kubectl apply -f -
exit 0
