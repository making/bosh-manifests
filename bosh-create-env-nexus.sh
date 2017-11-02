#!/bin/sh
bosh create-env nexus-standalone.yml \
     -v internal_ip=192.168.230.40 \
     --vars-store ./nexus-creds.yml \
     --var-file nexus_ssl.certificate=~/sslip.io/sslip.io.crt \
     --var-file nexus_ssl.private_key=~/sslip.io/sslip.io.key \
     --state=nexus-standalone-state.json
