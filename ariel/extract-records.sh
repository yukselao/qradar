#!/bin/bash

[[ -z "$1" ]] && echo "no parameter found " && exit 1
cd /store/ariel/events
echo INFO extract records_$(echo $d |tr '/' '_').lz4
for d in $@; do
	/bin/rm records_$(echo $d |tr '/' '_') &>/dev/null
	lz4 -d records_$(echo $d |tr '/' '_').lz4
	tar -xf records_$(echo $d |tr '/' '_')
	du -sh records/$d
done
