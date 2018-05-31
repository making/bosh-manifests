#!/bin/bash


bosh -d vault deploy <(sed 's|/var/vcap/jobs/vault/data|/var/vcap/store/vault|g' vault-boshrelease/manifests/vault.yml) \
     -o ops-files/vault-single.yml \
     -o ops-files/vault-static-ip.yml \
     -o ops-files/vault-add-concourse-cert.yml \
     -o ops-files/vault-unseal-keys.yml \
     -v external_ip=10.244.0.98 \
     --no-redact
