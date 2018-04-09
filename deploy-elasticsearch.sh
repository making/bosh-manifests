#!/bin/sh

bosh -d elasticsearch deploy elasticsearch-boshrelease/manifest/elasticsearch.yml \
     -o elasticsearch-boshrelease/manifest/add-azure-public-ip.yml \
     -o elasticsearch-boshrelease/manifest/add-kibana.yml \
     -o elasticsearch-boshrelease/manifest/support-https.yml \
     -o elasticsearch-boshrelease/manifest/support-https-for-kibana.yml \
     -o ops-files/elasticsearch-release.yml \
     -o ops-files/elasticsearch-share-master.yml \
     -v external_ip=${EXTERNAL_IP} \
     --var-file nginx.certificate=${HOME}/gdrive/sslip.io/sslip.io.crt \
     --var-file nginx.private_key=${HOME}/gdrive/sslip.io/sslip.io.key \
     --no-redact


