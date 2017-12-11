#!/bin/bash

bosh deploy -d concourse concourse.yml \
            -o ops-files/concourse-external-lb.yml \
            -o ops-files/concourse-external-postgres.yml \
            -v internal_ip=10.244.1.120 \
            -v external_ip=concourse.ik.am \
            -v postgres_host=192.168.220.40 \
            --no-redact


