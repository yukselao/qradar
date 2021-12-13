#!/bin/bash

if [[ "$1" == "-d" ]]; then

        #test parameters: qactl -d "2021-12-11 02:00" 60
        enddate="$2"
        minutes="$3"
        # remove minute indexes TODO
        echo INFO deleting old minute indexes
        echo CMD: /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -a -r
        /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -a -r
        echo done.


        #echo INFO creating minute indexes
        #/opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -a
        echo INFO deleting old super indexes
        echo CMD: /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -s -r
        /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -s -r
        echo done.
elif [[ "$1" == "-db" ]]; then
        #test parameters: qactl -db "2021-12-13 11:00" 60
        enddate="$2"
        minutes="$3"
        echo INFO creating minute indexes
        echo CMD: /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -a
        /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -a
        echo done.
        echo INFO deleting old super indexes
        echo CMD: /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -s -r
        /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -s -r
        echo done.
        echo INFO creating super indexes
        echo CMD: /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -s
        /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -s
        echo done.

        #once minute index olusturulacak -a;  dururken super i silecez; minute leri merge edip yeni super
        exit 1
fi

######
#test parameters: qactl 1111 "2021-12-11 01:00:00" "2021-12-11 01:59:59"
#####
key="$1"
cd /transient/ariel_proxy.ariel_proxy_server/data
echo /opt/qradar/bin/ariel_query -f /root/token -q "select $key from events where sourceip='0.1.0.0' START '$2' STOP '$3'"
/opt/qradar/bin/ariel_query -f /root/token -q "select $key from events where sourceip='0.1.0.0' START '$2' STOP '$3'" &>/dev/null
## TODO - add host parameter
#grep $key /var/log/audit/audit.log |grep commandapiuser |tail -1 |tr '[' '%'| tr ']' '%' | sed -r 's#.*%commandapiuser% %(.+)% %SECURE%.*#\1#'
metafile="$(ls -1 $(find /transient/ariel_proxy.ariel_proxy_server/data -name "*.alias" -type f -exec grep -l $key {} \; 2>/dev/null |awk -F '~' '{print $1}')*.meta 2>/dev/null |tail -1)"
datafilecount=$(cat $metafile |sed -r 's#.*<dataFileCount>(.+)</dataFileCount>.*#\1#')
echo "$key;$metafile;$datafilecount"
exit 0
