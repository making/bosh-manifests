#!/bin/bash

FILE=~/bosh-backup/credhub-import-`date +%F-%H-%M-%S`.yml

echo "credentials:" > $FILE
for n in `credhub find | grep name | sed 's/- name: //' | tr -d ' '`;do
        name=`echo $n | sed 's/BoshLiteDirector/Bosh Lite Director/'`

        yml=`credhub get -n "$name"`

        echo -n "- name: " >> $FILE
        bosh int --path /name <(cat <<EOF
$yml
EOF
) >> $FILE

        echo -n "  type: " >> $FILE
        type=`bosh int --path /type <(cat <<EOF
$yml
EOF
)`
        echo $type >> $FILE

        echo $type
        if [ "$type" == "password" ];then
          echo -n "  value: " >> $FILE
          bosh int --path /value <(cat <<EOF
$yml
EOF
) >> $FILE
        else
          echo "  value: " >> $FILE
          bosh int --path /value <(cat <<EOF
$yml
EOF
) | sed -e 's/^./    \0/g'>> $FILE
        fi
done

sed -i '/public_key_fingerprint/d' $FILE
sed -i '/password_hash/d' $FILE
