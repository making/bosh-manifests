#!/bin/bash

bosh deploy -d kafka \
  kafka-boshrelease/manifests/kafka.yml \
  -o kafka-boshrelease/manifests/operators/enable-jmx.yml \
  -o kafka-boshrelease/manifests/operators/enable-jaas.yml \
  -o kafka-boshrelease/manifests/operators/enable-tls.yml \
  -o <(
cat <<EOF
- type: replace
  path: /instance_groups/name=kafka/instances
  value: 1
- type: replace
  path: /instance_groups/name=zookeeper/instances
  value: 1
- type: replace
  path: /instance_groups/name=kafka-manager/instances
  value: 0
- type: replace
  path: /releases/name=kafka
  value:
    name: kafka
    version: latest
- type: remove
  path: /releases/name=zookeeper/stemcell
- type: remove
  path: /releases/name=bpm/stemcell
- type: replace
  path: /instance_groups/name=kafka/jobs/name=kafka/properties/advertised?/listener
  value:
  - ((kafka-external-host)):17440
- type: replace
  path: /instance_groups/name=kafka/networks/0/static_ips?
  value:
  - 10.244.1.121

EOF
) \
  --var-file kafka-tls.certificate=/etc/letsencrypt/live/ik.am/fullchain.pem \
  --var-file kafka-tls.private_key=/etc/letsencrypt/live/ik.am/privkey.pem \
  --var-file kafka-ca.certificate=<(curl https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt) \
  -v jmx_port=9999 \
  -v kafka-external-host=kafka.dev.ik.am \
  --no-redact \
  $@


