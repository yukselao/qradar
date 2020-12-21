#!/bin/bash

[[ -z "$1" ]] && echo "no parameter found " && exit 1
cd /store/ariel/events
echo INFO check daily log size

for d in $@; do
du -sh payloads/$d
du -sh records/$d
done
for d in $@; do
        echo $(du -sh -c $(find records/$d -type d -name lucene -o -name super) |grep total|awk '{print $1}')   records/lucene+super
done

