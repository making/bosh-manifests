#!/bin/sh
bosh create-env nexus-standalone.yml \
     -o ops-files/datadog-for-create-env.yml \
     -v internal_ip=192.168.230.40 \
     --vars-store ./nexus-creds.yml \
     --var-file nexus_ssl.certificate=~/sslip.io/sslip.io.crt \
     --var-file nexus_ssl.private_key=~/sslip.io/sslip.io.key \
     -v datadog-hostname=nexus \
     -v datadog-api-key=${DD_API_KEY} \
     --state=nexus-standalone-state.json
