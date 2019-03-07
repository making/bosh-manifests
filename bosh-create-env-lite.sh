#!/bin/sh

bosh create-env bosh-deployment/bosh.yml \
  -o bosh-deployment/virtualbox/cpi.yml \
  -o bosh-deployment/virtualbox/outbound-network.yml  \
  -o bosh-deployment/bosh-lite.yml \
  -o bosh-deployment/bosh-lite-runc.yml \
  -o bosh-deployment/uaa.yml \
  -o bosh-deployment/credhub.yml \
  -o bosh-deployment/jumpbox-user.yml \
  -o ops-files/director-size-lite.yml \
  -o ops-files/datadog-for-create-env.yml \
  -o ops-files/bosh-director-extern.yml \
  -o ops-files/director-node-exporter.yml \
  -o prometheus-boshrelease/manifests/operators/bosh/add-bosh-exporter-uaa-clients.yml \
  --vars-store bosh-lite-creds.yml \
  -v director_name=bosh-lite \
  -v internal_ip=192.168.50.6 \
  -v internal_gw=192.168.50.1 \
  -v internal_cidr=192.168.50.0/24 \
  -v outbound_network_name=NatNetwork \
  -v datadog-hostname=bosh-lite \
  -v datadog-api-key=${DD_API_KEY} \
  --state bosh-lite-state.json --recreate \
  --recreate
