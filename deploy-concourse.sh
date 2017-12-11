#!/bin/bash

bosh deploy -d concourse concourse-deployment/cluster/concourse.yml \
     -l concourse-deployment/versions.yml \
     -o concourse-deployment/cluster/operations/static-web.yml \
     -o concourse-deployment/cluster/operations/basic-auth.yml \
     -o ops-files/concourse-external-postgres.yml \
     -o ops-files/concourse-credhub.yml \
     -o ops-files/concourse-variables.yml \
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
     -v credhub_url=https://192.168.50.6:8844 \
     --var-file credhub_tls.ca=<(bosh int ~/bosh-deployment/creds.yml --path /credhub_ca/ca) \
     -v credhub_client_id=director_to_credhub \
     -v credhub_client_secret=`bosh int ~/bosh-deployment/creds.yml --path /uaa_clients_director_to_credhub` \
     --no-redact
