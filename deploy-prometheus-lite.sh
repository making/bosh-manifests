#!/bin/bash

bosh int ./bosh-lite-creds.yml --path /director_ssl/ca > /tmp/default_ca

bosh deploy -d prometheus prometheus-boshrelease/manifests/prometheus.yml  \
            -o prometheus-boshrelease/manifests/operators/monitor-bosh.yml \
            -o prometheus-boshrelease/manifests/operators/monitor-cf.yml \
            -o prometheus-boshrelease/manifests/operators/use-sqlite3.yml \
            -o prometheus-boshrelease/manifests/operators/monitor-node.yml \
            -o prometheus-boshrelease/manifests/operators/monitor-http-probe.yml \
            -o prometheus-boshrelease/manifests/operators/monitor-mysql.yml \
            -o prometheus-boshrelease/manifests/operators/monitor-kubernetes.yml \
            -o prometheus-boshrelease/manifests/operators/enable-bosh-uaa.yml \
            -o prometheus-boshrelease/manifests/operators/alertmanager-slack-receiver.yml \
            -o prometheus-boshrelease/manifests/operators/alertmanager-web-external-url.yml \
            -o ops-files/prometheus-pivotal-kpis-op.yml \
            -o ops-files/prometheus-nginx.yml \
            -o ops-files/prometheus-mysql.yml \
            -o ops-files/prometheus-lite.yml \
            -o ops-files/use-specific-stemcell.yml \
            -v stemcell_version="3468.13" \
            -v bosh_url=192.168.50.6 \
            --var-file bosh_ca_cert=/tmp/default_ca \
            -v bosh_username=admin \
            -v bosh_password=$(bosh int ./bosh-lite-creds.yml --path /admin_password) \
            -v uaa_bosh_exporter_client_secret=$(bosh int ./bosh-lite-creds.yml --path /uaa_bosh_exporter_client_secret) \
            -v metrics_environment=bosh-lite \
            -v alertmanager_slack_api_url=https://hooks.slack.com/services/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 \
            -v alertmanager_slack_channel=alert \
            -v alertmanager_web_external_url=https://alert-manager.ik.am \
            -v metron_deployment_name=cf \
            -v system_domain=202-241-169-198.sslip.io \
            -v skip_ssl_verify=true \
            -v traffic_controller_external_port=443 \
            -v metron_deployment_name=202-241-169-198.sslip.io \
            -v skip_ssl_verify=true \
            -v traffic_controller_external_port=4443 \
	    -v probe_endpoints="['https://api.202-241-169-198.sslip.io', 'https://foo.202-241-169-198.sslip.io']" \
            --no-redact

rm -f /tmp/default_ca
