#!/bin/bash

bosh deploy -d prometheus prometheus-boshrelease/manifests/prometheus.yml  \
  -o prometheus-boshrelease/manifests/operators/use-sqlite3.yml \
  -o prometheus-boshrelease/manifests/operators/alertmanager-slack-receiver.yml \
  -o prometheus-boshrelease/manifests/operators/alertmanager-web-external-url.yml \
  -o prometheus-boshrelease/manifests/operators/nginx-vm-extension.yml \
  -o prometheus-boshrelease/manifests/operators/monitor-bosh.yml \
  -o prometheus-boshrelease/manifests/operators/enable-bosh-uaa.yml \
  -o prometheus-boshrelease/manifests/operators/monitor-kubernetes.yml \
  -o ops-files/prometheus-vm-types.yml \
  -o ops-files/prometheus-disk-types.yml \
  -o ops-files/prometheus-vm-extensions.yml \
  -v alertmanager_slack_api_url=https://hooks.slack.com/services/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 \
  -v alertmanager_slack_channel=alert \
  -v alertmanager_web_external_url=https://alertmanager.bosh.tokyo \
  -v nginx_vm_extension=nginx-lb \
  -v bosh_url=${BOSH_ENVIRONMENT} \
  --var-file bosh_ca_cert=<(cat <<EOF
${BOSH_CA_CERT}
EOF) \
  -v bosh_username=admin \
  -v bosh_password=$(bosh int ../cfcr-manifests/bosh-aws-creds.yml --path /admin_password) \
  -v uaa_bosh_exporter_client_secret=$(bosh int ../cfcr-manifests/bosh-aws-creds.yml --path /uaa_bosh_exporter_client_secret) \
  -v metrics_environment=bosh-aws \
  -v kubernetes_apiserver_scheme=https \
  -v kubernetes_apiserver_ip=k8s.bosh.tokyo \
  -v kubernetes_apiserver_port=443 \
  --var-file kubernetes_kubeconfig=<(kubectl config view --minify=true --raw=true) \
  -v kubernetes_bearer_token=$(kubectl -n kube-system get secrets $(kubectl -n kube-system get serviceaccount clusterrole-aggregation-controller -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode) \
  -v skip_ssl_verify=true \
  --no-redact

