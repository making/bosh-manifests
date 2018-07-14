#!/bin/bash

bosh -d logstash deploy logstash-boshrelease/manifest/logstash.yml \
     -o logstash-boshrelease/manifest/add-lb.yml \
     -o logstash-boshrelease/manifest/instances.yml \
     -o logstash-boshrelease/manifest/azs.yml \
     -o logstash-boshrelease/manifest/types.yml \
     -o logstash-boshrelease/manifest/readiness-probe.yml \
     -o ops-files/logstash-consume-elasticsearch.yml \
     -v logstash_instances=1 \
     -v logstash_azs="[z1, z2, z3]" \
     -v logstash_disk_type="5120" \
     -v logstash_vm_type=minimal \
     -v readiness_probe_http_port=0 \
     -v readiness_probe_tcp_port=5514 \
     -o <(cat <<EOF
- type: replace
  path: /instance_groups/name=logstash/vm_extensions?/-
  value: spot-instance-t2.micro
EOF) \
--var-file logstash.conf=logstash.conf \
--no-redact
