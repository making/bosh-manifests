#!/bin/bash

bosh -d kafka deploy kafka-boshrelease/manifests/kafka.yml \
     -o ops-files/kafka-vms.yml \
     -o ops-files/add-kafka-public-ip-on-azure.yml \
     -o ops-files/add-kafka-pre-start-script.yml \
     -o <(kafka-boshrelease/manifests/operators/simple-topics.sh demo test hello) \
     --vars-store=kafka-creds.yml \
     --no-redact