#!/bin/bash

bosh deploy -d concourse concourse-deployment/cluster/concourse.yml \
     -l concourse-deployment/versions.yml \
     -o concourse-deployment/cluster/operations/static-web.yml \
     -o concourse-deployment/cluster/operations/basic-auth.yml \
     -o concourse-deployment/cluster/operations/external-postgres.yml \
     -o ops-files/concourse-emtpy-certs-path.yml \
     -o ops-files/use-specific-stemcell.yml \
     -o prometheus-boshrelease/manifests/operators/concourse/enable-prometheus-metrics.yml \
     -v stemcell_version="3468.21" \
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
     -v credhub_url=https://10.244.1.100:8844 \
     -v credhub-ip=10.244.1.100 \
     -v uaa-url=https://192.168.50.6:8443 \
     --var-file uaa-tls.ca=<(bosh int bosh-lite-creds.yml --path /uaa_ssl/ca) \
     --var-file uaa-jwt.public_key=<(bosh int bosh-lite-creds.yml --path /uaa_jwt_signing_key/public_key) \
     -v credhub_client_id=director_to_credhub \
     -v credhub_client_secret=`bosh int bosh-lite-creds.yml --path /uaa_clients_director_to_credhub` \
     --no-redact

# -o ops-files/concourse-credhub.yml \
# -o ops-files/concourse-credhub-external-postgres.yml \
# -o ops-files/concourse-variables.yml \
