#!/bin/bash
# Setup for Question 12: create the broken kubeconfig (wrong API server port)
mkdir -p /tmp/exam
sed 's/:6443/:2379/' /home/candidate/.kube/kubeconfig > /tmp/exam/super.kubeconfig
exit 0
