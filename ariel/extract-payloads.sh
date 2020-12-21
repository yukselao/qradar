#!/bin/bash

[[ -z "$1" ]] && echo "no parameter found " && exit 1
cd /store/ariel/events
echo INFO extract payloads_$(echo $d |tr '/' '_').lz4
for d in $@; do
	/bin/rm payloads_$(echo $d |tr '/' '_') &>/dev/null
	lz4 -d payloads_$(echo $d |tr '/' '_').lz4
	tar -xf payloads_$(echo $d |tr '/' '_')
	du -sh payloads/$d
done
