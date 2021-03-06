#!/bin/sh

FILE=~/bosh-backup/credhub-`date +%F-%H-%M-%S`.yml

for n in `credhub find | grep name | sed 's/- name: //' | tr -d ' '`;do 
	name=`echo $n | sed 's/BoshLiteDirector/Bosh Lite Director/'`
	credhub get -n "$name" >> $FILE
        echo "---" >> $FILE
done
