#!/bin/sh
bosh create-env postgres-standalone.yml \
     -v internal_ip=192.168.220.40 \
     -v postgres_database=atc \
     -v postgres_user=atc \
     --vars-store ./postgres-creds.yml
