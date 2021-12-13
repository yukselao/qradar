#!/bin/bash

key="$1"
cd /transient/ariel_proxy.ariel_proxy_server/data
/opt/qradar/bin/ariel_query -f /root/token -q "select $key from events where sourceip='0.1.0.0' START '2021-12-12 00:00:00' STOP '2021-12-13 00:00:00'" &>/dev/null
metafile="$(ls -1 $(find /transient/ariel_proxy.ariel_proxy_server/data -name "*.alias" -type f -exec grep -l 181818 {} \; 2>/dev/null |awk -F '~' '{print $1}')*.meta 2>/dev/null)"
datafilecount=$(cat $metafile |sed -r 's#.*<dataFileCount>(.+)</dataFileCount>.*#\1#')
echo "$key;$metafile;$datafilecount"
exit 0
