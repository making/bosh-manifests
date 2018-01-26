#!/bin/bash
set -e

bosh deploy -d cfcr kubo-deployment/manifests/cfcr.yml \
            -o ops-files/use-specific-stemcell.yml \
            -o ops-files/kubernetes-kubo-0.13.0.yml \
            -o ops-files/kubernetes-static-ips.yml \
            -o ops-files/kubernetes-single-worker.yml \
            -o ops-files/kubernetes-dummy-cloud-provider.yml \
            -v stemcell_version="3468.21" \
            -v kubernetes_master_host=10.244.1.92 \
            -v kubernetes_worker_hosts='["10.244.1.93"]' \
            --no-redact
