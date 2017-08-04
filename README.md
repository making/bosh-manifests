
## Runtime Config

```
bosh update-runtime-config <(\
    bosh int runtime-config.yml \
    -o ops-files/addons/node-exporter.yml \
    -o ops-files/addons/clamav.yml \
    -o ops-files/addons/fim.yml \
    -o ops-files/addons/syslog.yml \
    -o ops-files/addons/syslog-exclude.yml \
    -v syslog_address=10.244.0.230 \
    -v syslog_port=10514 \
    )
```
