#!/bin/bash

bosh deploy -d prometheus prometheus/manifests/prometheus.yml  \
            -o ops-files/prometheus-azure.yml \
            -o prometheus/manifests/operators/monitor-bosh.yml \
            -o prometheus/manifests/operators/enable-bosh-uaa.yml \
            -o prometheus/manifests/operators/monitor-node.yml \
            -o prometheus/manifests/operators/monitor-influxdb.yml \
            -o prometheus/manifests/operators/monitor-concourse.yml \
            -o prometheus/manifests/operators/alertmanager-slack-receiver.yml \
            -v bosh_url=10.0.0.6 \
            --var-file bosh_ca_cert=~/default_ca \
            -v bosh_username=admin \
            -v bosh_password=$(bosh int ../creds.yml --path /admin_password) \
            -v uaa_bosh_exporter_client_secret=$(bosh int ../creds.yml --path /uaa_bosh_exporter_client_secret) \
            -v metrics_environment=bosh-1
