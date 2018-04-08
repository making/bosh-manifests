#!/bin/bash
set -e

bosh deploy -d cfcr kubo-deployment/manifests/cfcr.yml \
            -o kubo-deployment/manifests/ops-files/add-oidc-endpoint.yml \
            -o kubo-deployment/manifests/ops-files/system-specs.yml \
            -o ops-files/use-specific-stemcell.yml \
            -o ops-files/kubernetes-kubo-0.15.0.yml \
            -o ops-files/kubernetes-static-ips.yml \
            -o ops-files/kubernetes-single-worker.yml \
            -o ops-files/kubernetes-add-alternative-name.yml \
            -o ops-files/kubernetes-remove-unused-oidc-properties.yml \
            -o ops-files/kubernetes-remove-cloud-provider.yml \
            -v stemcell_version="3468.21" \
            -v kubernetes_master_host=10.244.1.92 \
            -v kubernetes_worker_hosts='["10.244.1.93"]' \
            -v add_alternative_name=gmo.ik.am \
            -v oidc_issuer_url=https://keycloak.ik.am/auth/realms/home \
            -v oidc_client_id=kubernetes \
            -v oidc_username_claim=preferred_username \
            -v authorization_mode=RBAC \
            --no-redact
