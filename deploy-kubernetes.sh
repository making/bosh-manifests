#!/bin/bash
set -e

bosh deploy -d cfcr kubo-deployment/manifests/cfcr.yml \
            -o ops-files/use-specific-stemcell.yml \
            -o ops-files/kubernetes-kubo-0.14.0.yml \
            -o ops-files/kubernetes-static-ips.yml \
            -o ops-files/kubernetes-single-worker.yml \
            -o ops-files/kubernetes-add-alternative-name.yml \
            -o ops-files/kubernetes-oidc.yml \
            -o ops-files/kubernetes-oidc-username.yml \
            -v stemcell_version="3468.21" \
            -v kubernetes_master_host=10.244.1.92 \
            -v kubernetes_worker_hosts='["10.244.1.93"]' \
            -v add_alternative_name=gmo.ik.am \
            -v oidc-issuer-url=https://keycloak.ik.am/auth/realms/home \
            -v oidc-client-id=kubernetes \
            -v oidc-username-claim=preferred_username \
            --no-redact
