#!/bin/bash

source elastic-stack-azure-env.sh

bosh -d elastic-stack deploy elastic-stack-bosh-deployment/elastic-stack.yml \
     -l elastic-stack-bosh-deployment/versions.yml \
     -o elastic-stack-bosh-deployment/ops-files/vm_types.yml \
     -o elastic-stack-bosh-deployment/ops-files/disk_types.yml \
     -o elastic-stack-bosh-deployment/ops-files/instances.yml \
     -o elastic-stack-bosh-deployment/ops-files/networks.yml \
     -o elastic-stack-bosh-deployment/ops-files/azs.yml \
     -o elastic-stack-bosh-deployment/ops-files/elasticsearch-add-plugins-master.yml \
     -o elastic-stack-bosh-deployment/ops-files/elasticsearch-https-and-basic-auth.yml \
     -o elastic-stack-bosh-deployment/ops-files/logstash-readiness-probe.yml \
     -o elastic-stack-bosh-deployment/ops-files/logstash-tls.yml \
     -o elastic-stack-bosh-deployment/ops-files/logstash-elasticsearch-https.yml \
     -o elastic-stack-bosh-deployment/ops-files/logstash-elasticsearch-basic-auth.yml \
     -o elastic-stack-bosh-deployment/ops-files/kibana-https-and-basic-auth.yml \
     -o elastic-stack-bosh-deployment/ops-files/kibana-elasticsearch-https.yml \
     -o elastic-stack-bosh-deployment/ops-files/kibana-elasticsearch-basic-auth.yml \
     -o elastic-stack-bosh-deployment/ops-files/curator.yml \
     -o elastic-stack-bosh-deployment/ops-files/curator-cron.yml \
     -o elastic-stack-bosh-deployment/ops-files/elastalert.yml \
     -o elastic-stack-bosh-deployment/ops-files/elastalert-rule-monitor-error-log.yml \
     -o elastic-stack-bosh-deployment/ops-files/elasticsearch-share-link.yml \
     -o elastic-stack-bosh-deployment/ops-files/azure/elasticsearch-add-public-ip.yml \
     -o elastic-stack-bosh-deployment/ops-files/azure/logstash-add-public-ip.yml \
     -o elastic-stack-bosh-deployment/ops-files/azure/kibana-add-public-ip.yml \
     --var-file logstash.conf=logstash.conf \
     -v elasticsearch_master_instances=1 \
     -v elasticsearch_master_vm_type=small \
     -v elasticsearch_master_disk_type=10GB \
     -v elasticsearch_master_network=default \
     -v elasticsearch_master_azs="[z1, z2, z3]" \
     -v elasticsearch_master_external_ip=${ELASTICSEARCH_MASTER_EXTERNAL_IP} \
     -v elasticsearch_data_instances=1 \
     -v elasticsearch_data_vm_type=small \
     -v elasticsearch_data_disk_type=5GB \
     -v elasticsearch_data_network=default \
     -v elasticsearch_data_azs="[z1, z2, z3]" \
     -v elasticsearch_username=admin \
     -v logstash_instances=1 \
     -v logstash_vm_type=minimal \
     -v logstash_disk_type=default \
     -v logstash_network=default \
     -v logstash_azs="[z1, z2, z3]" \
     -v logstash_external_ip=${LOGSTASH_EXTERNRL_IP} \
     -v logstash_readiness_probe_http_port=0 \
     -v logstash_readiness_probe_tcp_port=5514 \
     -v kibana_external_ip=${KIBANA_EXTERNRL_IP} \
     -v kibana_instances=1 \
     -v kibana_vm_type=minimal \
     -v kibana_network=default \
     -v kibana_azs="[z1, z2, z3]" \
     -v kibana_username=admin \
     -v kibana_elasticsearch_ssl_verification_mode=none \
     --var-file curator_actions=actions.yml \
     -v slack_webhook_url=${SLACK_WEBHOOK_URL} \
     --var-file nginx.certificate=${HOME}/gdrive/letsencrypt/ik.am/fullchain.pem \
     --var-file nginx.private_key=${HOME}/gdrive/letsencrypt/ik.am/privkey.pem \
     --no-redact \
     --vars-store=es-creds.yml \
     $@



