#!/bin/sh

bosh -d logstash deploy logstash-boshrelease/manifest/logstash.yml \
     -o logstash-boshrelease/manifest/add-public-ip.yml \
     -o logstash-boshrelease/manifest/add-tls.yml \
     -o ops-files/logstash-change-vm-type.yml \
     -o ops-files/logstash-release.yml \
     --var-file logstash.conf=logstash.conf \
     -v external_ip=${EXTERNAL_IP} \
     --var-file logstash_tls.certificate=${HOME}/gdrive/sslip.io/sslip.io.crt \
     --var-file logstash_tls.private_key=${HOME}/gdrive/sslip.io/sslip.io.key \
     --no-redact
