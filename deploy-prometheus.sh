#!/bin/bash

bosh deploy -d prometheus prometheus-boshrelease/manifests/prometheus.yml  \
            -o ops-files/prometheus-azure.yml \
            -o prometheus-boshrelease/manifests/operators/monitor-bosh.yml \
            -o prometheus-boshrelease/manifests/operators/enable-bosh-uaa.yml \
            -o prometheus-boshrelease/manifests/operators/monitor-node.yml \
            -o prometheus-boshrelease/manifests/operators/monitor-influxdb.yml \
            -o prometheus-boshrelease/manifests/operators/monitor-concourse.yml \
            -o prometheus-boshrelease/manifests/operators/alertmanager-slack-receiver.yml \
            -o ops-files/prometheus-disable-postgres.yml \
            -v bosh_url=10.0.0.6 \
            --var-file bosh_ca_cert=~/default_ca \
            -v bosh_username=admin \
            -v bosh_password=$(bosh int ./bosh-azure-creds.yml --path /admin_password) \
            -v uaa_bosh_exporter_client_secret=$(bosh int ../bosh-azure-creds.yml --path /uaa_bosh_exporter_client_secret) \
            -v metrics_environment=bosh-1
