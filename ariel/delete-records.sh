#!/bin/bash

[[ -z "$1" ]] && echo "no parameter found " && exit 1
cd /store/ariel/events
echo INFO checking records/$d for before deletion task
for d in $@; do
	du -sh records/$d
done
for d in $@; do
	rm -fr records/$d
	if [ $? -eq 0 ]; then
		echo INFO records/$d deleted successfully
	fi
done
echo INFO checking records/$d for validation deletion task
for d in $@; do
	du -sh records/$d &>/dev/null
	if [ $? -ne 0 ]; then
		echo INFO records/$d not found
	fi
done
