#!/bin/bash

[[ -z "$1" ]] && echo "no parameter found " && exit 1
cd /store/ariel/events
echo INFO before deletion task check daily log size

for d in $@; do
du -sh records/$d
done


for d in $@; do
	echo INFO delete payloads/$d for before deletion task
	find records/$d -type d -name lucene -o -name super |xargs /bin/rm -fr
	cd /store/ariel/events
done

echo INFO after deletion task check daily log size
for d in $@; do
du -sh records/$d
done
