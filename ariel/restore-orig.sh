#!/bin/bash

cd /store/ariel/events
for d in $@; do
        /bin/cp -fr  /backup/orig/records_$(echo $d |tr '/' '_').lz4 .
        /bin/cp -fr  /backup/orig/payloads_$(echo $d |tr '/' '_').lz4 .
        du -sh /backup/orig/records_$(echo $d |tr '/' '_').lz4
        du -sh /backup/orig/payloads_$(echo $d |tr '/' '_').lz4
        /bin/rm payloads_$(echo $d |tr '/' '_')
        lz4 -d payloads_$(echo $d |tr '/' '_').lz4
        tar -xf payloads_$(echo $d |tr '/' '_')
        du -sh payloads/$d
        /bin/rm records_$(echo $d |tr '/' '_')
        lz4 -d records_$(echo $d |tr '/' '_').lz4
        tar -xf records_$(echo $d |tr '/' '_')
        du -sh records/$d

done

