#!/bin/bash

bosh deploy -d concourse concourse-deployment/cluster/concourse.yml \
     -l concourse-deployment/versions.yml \
     -o concourse-deployment/cluster/operations/static-web.yml \
     -o concourse-deployment/cluster/operations/basic-auth.yml \
     -o ops-files/concourse-external-postgres.yml \
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
     --no-redact

# bosh deploy -d concourse concourse.yml \
#             -o ops-files/concourse-external-lb.yml \
#             -o ops-files/concourse-external-postgres.yml \
#             -v internal_ip=10.244.1.120 \
#             -v external_ip=concourse.ik.am \
#             -v postgres_host=192.168.220.40 \
#             --no-redact


