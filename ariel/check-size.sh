#!/bin/bash

[[ -z "$1" ]] && echo "no parameter found " && exit 1
cd /store/ariel/events
echo INFO check daily log size

for d in $@; do
du -sh payloads/$d
du -sh records/$d
done


