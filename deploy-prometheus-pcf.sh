#!/bin/bash

bosh2 -n deploy -d prometheus prometheus-boshrelease/manifests/prometheus.yml  \
            -o prometheus-boshrelease/manifests/operators/monitor-cf.yml \
            -o ops-files/prometheus-pcf.yml \
            -o prometheus-boshrelease/manifests/operators/monitor-bosh.yml \
            -o prometheus-boshrelease/manifests/operators/enable-bosh-uaa.yml \
            -o prometheus-boshrelease/manifests/operators/use-sqlite3.yml \
            -v bosh_url=10.0.0.10 \
            --var-file bosh_ca_cert=/var/tempest/workspaces/default/root_ca_certificate \
            -v uaa_bosh_exporter_client_secret=prometheus-client-secret \
            -v uaa_clients_cf_exporter_secret=prometheus-client-secret \
            -v uaa_clients_firehose_exporter_secret=prometheus-client-secret \
            -v metrics_environment=p-bosh \
            -v system_domain=system.g.ik.am \
            -v metron_deployment_name=cf \
            -v skip_ssl_verify=true \
            -v traffic_controller_external_port=443 \
            --vars-store=prom_creds.yml
