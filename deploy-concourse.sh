#!/bin/bash

bosh deploy -d concourse concourse-deployment/cluster/concourse.yml \
     -l concourse-deployment/versions.yml \
     -o concourse-deployment/cluster/operations/static-web.yml \
     -o concourse-deployment/cluster/operations/basic-auth.yml \
     -o concourse-deployment/cluster/operations/external-postgres.yml \
     -o concourse-deployment/cluster/operations/enable-global-resources.yml \
     -o ops-files/use-specific-stemcell.yml \
     -o ops-files/concourse-teams.yml \
     -o ops-files/concourse-variables.yml \
     -o ops-files/concourse-prometheus.yml \
     -o <(cat <<EOF
EOF) \
     -v stemcell_version="97" \
     -v web_ip=10.244.1.120 \
     -v external_url=https://concourse.ik.am \
     -v network_name=default \
     -v web_vm_type=default \
     -v db_vm_type=default \
     -v db_persistent_disk_type=default \
     -v worker_vm_type=default \
     -v deployment_name=concourse \
     -v postgres_host=192.168.220.40 \
     -v postgres_port=5432 \
     -v postgres_role=atc \
     --no-redact

#     -o concourse-deployment/cluster/operations/vault-tls-cert-auth.yml \
# -o ops-files/concourse-credhub.yml \
# -o ops-files/concourse-credhub-external-postgres.yml \
# -o ops-files/concourse-variables.yml \
