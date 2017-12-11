#!/bin/sh

target=postgres
ip=192.168.220.40

bosh int ${target}-creds.yml --path /jumpbox_ssh/private_key > ${target}.pem
chmod 600 ${target}.pem

ssh jumpbox@${ip} -i ${target}.pem 'sudo /var/vcap/packages/postgres-9.6.4/bin/pg_dumpall --username=vcap --database=atc --clean --if-exists' > backup-`date +%F-%H-%M-%S`.sql

rm -f ${target}.pem

