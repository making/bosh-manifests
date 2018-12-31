#!/bin/bash

source elastic-stack-azure-env.sh

bosh -d elastic-stack deploy elk.yml \
     --var-file logstash.conf=syslog_standard.conf \
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
     --vars-store=es-creds.yml \
     --no-redact \
     $@



