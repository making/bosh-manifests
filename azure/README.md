### Director

```
bosh create-env bosh-deployment/bosh.yml \
    --state=state.json \
    --vars-store=creds.yml \
    -o bosh-deployment/azure/cpi.yml \
    -o bosh-deployment/uaa.yml \
    -o bosh-deployment/credhub.yml \
    -o bosh-manifests/azure/cheap-director.yml \
    -v director_name=bosh-1 \
    -v internal_cidr=10.0.0.0/24 \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    -v vnet_name=boshvnet-crp \
    -v subnet_name=Bosh \
    -v subscription_id=${AZURE_SUBSCRIPTION_ID} \
    -v tenant_id=${AZURE_TENANT_ID} \
    -v client_id=${AZURE_CLIENT_ID} \
    -v client_secret=${AZURE_CLIENT_SECRET} \
    -v resource_group_name=bosh-rg \
    -v storage_account_name=${AZURE_STORAGE_ACCOUNT_NAME} \
    -v default_security_group=nsg-bosh
```


### Cloud Config

```
bosh update-cloud-config bosh-deployment/azure/cloud-config.yml \
    -o bosh-manifests/azure/cheap-cloud-config.yml \
    -o bosh-manifests/azure/ephemeral-disk-extentison.yml \
    -v internal_cidr=10.0.16.0/20 \
    -v internal_gw=10.0.16.1 \
    -v vnet_name=boshvnet-crp \
    -v subnet_name=CloudFoundry \
    -v security_group=nsg-cf
```
