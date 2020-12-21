#!/bin/bash

##
# Usage: 
# ./create-backup.sh 2020/11/9 2020/11/10 2020/11/11 2020/11/12 2020/11/13 2020/11/14
# records ve payload dizinlerini lz4 formatinda compress edip, size bilgilerini goruntuler
# Logs.
# [root@qradar events]# ./create-backup.sh 2020/11/20 2020/11/21 2020/11/22
# 201M    records_2020_11_20.lz4
# 104M    payloads_2020_11_20.lz4
# 226M    records_2020_11_21.lz4
# 164M    payloads_2020_11_21.lz4
# 224M    records_2020_11_22.lz4
# 164M    payloads_2020_11_22.lz4
##
mkdir -p /backup
cd /store/ariel/events
for d in $@; do
	tar -pcf - records/$d | lz4 > records_$(echo $d |tr '/' '_').lz4
	tar -pcf - payloads/$d | lz4 > payloads_$(echo $d |tr '/' '_').lz4
	mv records_$(echo $d |tr '/' '_').lz4 /backup/
	mv payloads_$(echo $d |tr '/' '_').lz4 /backup/
	du -sh /backup/records_$(echo $d |tr '/' '_').lz4
	du -sh /backup/payloads_$(echo $d |tr '/' '_').lz4
done
