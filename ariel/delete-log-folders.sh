#!/bin/bash

[[ -z "$1" ]] && echo "no parameter found " && exit 1
cd /store/ariel/events
for d in $@; do
	rm -fr payloads/$d
	if [ $? -eq 0 ]; then
		echo INFO payloads/$d deleted successfully
	fi
	rm -fr records/$d
	if [ $? -eq 0 ]; then
		echo INFO records/$d deleted successfully
	fi
done
echo INFO checking payloads/$d for validation deletion task
for d in $@; do
	du -sh payloads/$d &>/dev/null
	if [ $? -ne 0 ]; then
		echo INFO payloads/$d not found
	fi
done
echo INFO checking records/$d for validation deletion task
for d in $@; do
	du -sh records/$d &>/dev/null
	if [ $? -ne 0 ]; then
		echo INFO records/$d not found
	fi
done
