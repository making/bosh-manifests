#!/bin/bash

source elastic-stack-azure-env.sh

bosh -d elastic-stack deploy elk.yml \
     -l elastic-stack-bosh-deployment/versions.yml \
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
     --var-file input-01-tcp.conf=logstash/input-01-tcp.conf \
     --var-file filter-00-prefilter.conf=logstash/filter-00-prefilter.conf \
     --var-file filter-01-syslog.conf=logstash/filter-01-syslog.conf \
     --var-file filter-02-oratos.conf=logstash/filter-02-oratos.conf \
     --var-file filter-99-cleanup.conf=logstash/filter-99-cleanup.conf \
     --var-file output-01-es.conf=logstash/output-01-es.conf \
     --var-file output-02-stdout.conf=logstash/output-02-stdout.conf \
     -o elastic-stack-bosh-deployment/ops-files/elasticsearch-allow-ingest.yml \
     -o <(cat <<EOF
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=logstash/properties/logstash/pipelines?
  value:
  - name: oratos
    config:
      input-01-tcp: ((input-01-tcp.conf))
      filter-00-prefilter: ((filter-00-prefilter.conf))
      filter-01-syslog: ((filter-01-syslog.conf))
      filter-02-oratos: ((filter-02-oratos.conf))
      filter-99-cleanup: ((filter-99-cleanup.conf))
      output-01-es: ((output-01-es.conf))
      output-02-stdout: ((output-02-stdout.conf))
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/-
  value:
    consumes:
      elasticsearch:
        from: elasticsearch-master
    name: elasticsearch-index-templates
    release: elasticsearch
    lifecycle: errand
    properties: 
      elasticsearch:
        index:
          template:
          - zero_replica: |
              {
                "index_patterns": ["syslog-*", "zipkin*", "elasticalert*"],
                "settings": {
                  "number_of_replicas": 0
                }
              }
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=elasticsearch/properties/elasticsearch/plugins?/-
  value: 
    epository-s3: /var/vcap/packages/repository-s3/repository-s3.zip
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=elasticsearch/properties/elasticsearch/plugin_install_opts?
  value: 
  - --batch
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/-
  value:
    name: repository-s3
    release: elasticsearch
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=elasticsearch/properties/elasticsearch/jvm_options?
  value: 
  - -Des.allow_insecure_settings=true
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/-
  value:
    name: elasticsearch-snapshot
    release: elasticsearch
    lifecycle: errand
    consumes:
      elasticsearch:
        from: elasticsearch-master
    properties:
      elasticsearch:
        snapshots:
          type: s3
          repository: ((elasticsearch-snapshot.repository))
          settings:
            bucket: ((elasticsearch-snapshot.bucket))
            endpoint: ((elasticsearch-snapshot.endpoint))
            access_key: ((elasticsearch-snapshot.access_key))
            secret_key: ((elasticsearch-snapshot.secret_key))
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=logstash/properties/logstash/config_options?/queue.type
  value: persisted
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=logstash/properties/logstash/jvm?/heap_size
  value: 1g
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=elasticsearch/properties/elasticsearch/config_options?
  value:
    xpack.monitoring.collection.enabled: true
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=kibana/properties/kibana/config_options?
  value:
    xpack.infra.enabled: true
    xpack.infra.sources.default.logAlias: "syslog-*"
    xpack.monitoring.enabled: true
    xpack.monitoring.kibana.collection.enabled: true
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=logstash/properties/logstash/config_options?/xpack.monitoring.enabled
  value: true
- type: replace
  path: /instance_groups/name=elasticsearch-master/jobs/name=logstash/properties/logstash/config_options?/xpack.monitoring.elasticsearch.url
  value: __ES_HOSTS__
- type: replace
  path: /releases/name=elasticsearch
  value:
    name: elasticsearch
    sha1: 79a2cd84f85387de97c4a91b26f147e1773d8922
    version: 0.18.0_el 
- type: replace
  path: /releases/name=logstash
  value:
    name: logstash
    sha1: be3056d246b3eeb596f50b766f22d75361005e55
    version: 0.10.1_el 
- type: replace
  path: /releases/name=kibana
  value:
    name: kibana
    sha1: c161308b6a767c1c997708ce7389ddbe1df65bae
    version: 0.11.1_el 

EOF) \
     --no-redact \
     $@



