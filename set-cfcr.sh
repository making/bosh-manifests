#!/bin/bash
set -e

export admin_password=$(credhub get -n /bosh-lite/cfcr/kubo-admin-password | bosh int --path /value -)
export master_host=$(bosh int <(bosh instances -d cfcr --json) --path /Tables/0/Rows/0/ips)
export cluster_name=cfcr
export user_name=admin
export context_name=cfcr

kubectl config set-cluster "${cluster_name}"   --server="https://${master_host}:8443"   --insecure-skip-tls-verify=true
kubectl config set-credentials "${user_name}" --token="${admin_password}"
kubectl config set-context "${context_name}" --cluster="${cluster_name}" --user="${user_name}"
kubectl config use-context "${context_name}"


kubectl get node -o wide
kubectl get all -n kube-system
