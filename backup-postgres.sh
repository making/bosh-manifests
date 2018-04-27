#!/bin/sh

target=postgres
ip=192.168.220.40

bosh int ${target}-creds.yml --path /jumpbox_ssh/private_key > ${target}.pem
chmod 600 ${target}.pem

#databases="$databases atc"
#databases="$databases credhub"
databases="$databases director_uaa"
#databases="$databases director_credhub"
date=`date +%F-%H-%M-%S`
for d in $databases;do
  echo "backing up $d ..."
  ssh jumpbox@${ip} -i ${target}.pem "sudo /var/vcap/packages/postgres-9.6.4/bin/pg_dumpall --username=vcap --database=$d --clean --if-exists" > backup-$d-$date.sql
done

rm -f ${target}.pem

