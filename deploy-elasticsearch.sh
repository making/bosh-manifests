#!/bin/bash

bosh -d elasticsearch deploy elasticsearch-boshrelease/manifest/elasticsearch.yml \
     -o ops-files/elasticsearch-release.yml \
     -o elasticsearch-boshrelease/manifest/add-kibana.yml \
     -o elasticsearch-boshrelease/manifest/master-azs.yml \
     -o elasticsearch-boshrelease/manifest/master-instances.yml \
     -o elasticsearch-boshrelease/manifest/master-types.yml \
     -o elasticsearch-boshrelease/manifest/add-data-nodes.yml \
     -o elasticsearch-boshrelease/manifest/add-lb.yml \
     -o elasticsearch-boshrelease/manifest/share-master.yml \
     -o elasticsearch-boshrelease/manifest/set-minimum-master-nodes-one.yml \
     -o <(cat <<EOF
- type: replace
  path: /instance_groups/name=elasticsearch-master/vm_extensions?/-
  value: spot-instance-t2.micro
- type: replace
  path: /instance_groups/name=elasticsearch-data/vm_extensions?/-
  value: spot-instance-t2.micro
EOF) \
     -v master_nodes_azs="[z1,z2,z3]" \
     -v master_nodes_instances=1 \
     -v master_nodes_vm_type=minimal \
     -v master_nodes_disk_type=5120 \
     -v data_nodes_azs="[z1,z2,z3]" \
     -v data_nodes_instances=1 \
     -v data_nodes_vm_type=minimal \
     -v data_nodes_disk_type=5120 \
     --no-redact


