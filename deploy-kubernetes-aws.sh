#!/bin/bash
set -e

bosh -n update-cloud-config <(bosh cloud-config) -o ops-files/kubernetes-aws-instance-profile-cloud-config.yml

bosh deploy -d cfcr kubo-deployment/manifests/cfcr.yml \
            -o ops-files/use-specific-stemcell.yml \
            -o ops-files/kubernetes-kubo-0.12.0.yml \
            -o ops-files/kubernetes-static-ips.yml \
            -o ops-files/kubernetes-single-worker.yml \
            -o ops-files/kubernetes-remove-z3.yml \
            -o ops-files/kubernetes-aws-instance-profile.yml \
            -o kubo-deployment/manifests/ops-files/iaas/aws/cloud-provider.yml \
            -o kubo-deployment/manifests/ops-files/iaas/aws/lb.yml \
            -o kubo-deployment/manifests/ops-files/vm-types.yml \
            -v stemcell_version="3468.13" \
            -v kubernetes_master_host=10.0.31.192 \
            -v kubernetes_worker_hosts='["10.0.31.193"]' \
            -v master_vm_type=sharedcpu \
            -v worker_vm_type=small \
            -v kubernetes_cluster_tag=cfcr \
            --no-redact