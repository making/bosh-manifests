#!/bin/sh
bosh create-env postgres-standalone.yml \
     -o ops-files/datadog-for-create-env.yml \
     -v internal_ip=192.168.220.40 \
     -v postgres_database=atc \
     -v postgres_user=atc \
     -v datadog-hostname=postgres \
     -v datadog-api-key=${DD_API_KEY} \
     --vars-store ./postgres-creds.yml
