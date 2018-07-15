#!/bin/bash

bosh -d elastic-stack deploy elastic-stack-bosh-deployment/elastic-stack.yml \
     -l elastic-stack-bosh-deployment/versions.yml \
     -o elastic-stack-bosh-deployment/ops-files/vm_types.yml \
     -o elastic-stack-bosh-deployment/ops-files/disk_types.yml \
     -o elastic-stack-bosh-deployment/ops-files/instances.yml \
     -o elastic-stack-bosh-deployment/ops-files/networks.yml \
     -o elastic-stack-bosh-deployment/ops-files/azs.yml \
     -o elastic-stack-bosh-deployment/ops-files/elasticsearch-add-lb.yml \
     -o elastic-stack-bosh-deployment/ops-files/elasticsearch-add-data-nodes.yml \
     -o elastic-stack-bosh-deployment/ops-files/elasticsearch-add-plugins-master.yml \
     -o elastic-stack-bosh-deployment/ops-files/elasticsearch-add-plugins-data.yml \
     -o elastic-stack-bosh-deployment/ops-files/logstash-add-lb.yml \
     -o elastic-stack-bosh-deployment/ops-files/logstash-readiness-probe.yml \
     -o elastic-stack-bosh-deployment/ops-files/kibana-https.yml \
     --var-file logstash.conf=logstash.conf \
     -o <(cat <<EOF
- type: replace
  path: /instance_groups/name=elasticsearch-master/vm_extensions?/-
  value: spot-instance-t2.micro
- type: replace
  path: /instance_groups/name=elasticsearch-data/vm_extensions?/-
  value: spot-instance-t2.micro
- type: replace
  path: /instance_groups/name=logstash/vm_extensions?/-
  value: spot-instance-t2.micro
EOF) \
     -v elasticsearch_master_instances=1 \
     -v elasticsearch_master_vm_type=minimal \
     -v elasticsearch_master_disk_type=5120 \
     -v elasticsearch_master_network=default \
     -v elasticsearch_master_azs="[z1, z2, z3]" \
     -v elasticsearch_data_instances=1 \
     -v elasticsearch_data_vm_type=minimal \
     -v elasticsearch_data_disk_type=5120 \
     -v elasticsearch_data_network=default \
     -v elasticsearch_data_azs="[z1, z2, z3]" \
     -v logstash_instances=1 \
     -v logstash_vm_type=minimal \
     -v logstash_disk_type=5120 \
     -v logstash_network=default \
     -v logstash_azs="[z1, z2, z3]" \
     -v logstash_readiness_probe_http_port=0 \
     -v logstash_readiness_probe_tcp_port=5514 \
     --no-redact
