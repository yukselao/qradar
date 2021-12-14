#!/bin/bash

consoleip="10.10.2.10"
apitoken="7d9b79cb-304c-43c6-a8ab-2e8fbdedd7aa"

echo $apitoken > /tmp/mytoken
if [[ "$1" == "-h" ]]; then
echo 'Usage:
--
Delete minute, super indexes:'
echo $0 -d '"2021/12/13 11:00" 60'
echo '
Rebuild minute, super indexes:'
echo $0 -db '"2021/12/13 11:00" 60'
echo '
List API search caches with AQLs:'
echo $0 -apicachelist
echo '
Delete a API search cache:'
echo $0 -ds 732c9c2a-c0f1-49e6-8e20-3d4568cecea4
echo '
Perform a search and check dataFilecounter:'
echo $0 -checkdatafilecount 1991 '"2021-12-13 10:00:00" "2021-12-13 10:59:00" 0.2.0.1'
exit 0

elif [[ "$1" == "-ds" ]]; then
searchid="$2"
curl -k -S -X DELETE -H 'Version: 16.0' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches/$searchid" --header "SEC: $apitoken"


elif [[ "$1" == "-d" ]]; then

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
elif [[ "$1" == "-apicachelist" ]]; then
        key="$2"
        #curl -k -S -X GET -H 'Range: items=0-10000' -H 'Version: 16.0' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches" --header "SEC: $apitoken" 2>/dev/null   |jq '.[]' |tr -d '"'
        i=0
        for searchid in $(curl -k -S -X GET -H 'Range: items=0-100' -H 'Version: 16.0' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches" --header "SEC: $apitoken" 2>/dev/null |jq '.[]' |tr -d '"'); do
                i=$((i+1))
                #echo INFO searchid=$searchid
                aql="$(curl -k -S -X POST -H "SEC: $apitoken" -H 'Version: 16.0' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches/$searchid" 2>/dev/null | jq '.query_string')"
                if [[ "$aql" != "" ]]; then
                                echo SearchId: $searchid:, $aql >> all-searches.out
                                echo INFO delete $searchid
                                curl -k -S -X DELETE -H "SEC: $apitoken" -H 'Version: 16.0' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches/$searchid" 2>/dev/null | jq '.status'

                fi
        done
        exit 0
elif [[ "$1" == "-db" ]]; then
        #test parameters: qactl -db "2021-12-13 11:00" 60
        enddate="$2"
        minutes="$3"
        # remove minute indexes TODO
        echo INFO deleting old minute indexes
        echo CMD: /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -a -r
        /opt/qradar/bin/ariel_offline_indexer.sh -n events -v -t "$enddate" -d $3 -a -r
        echo done.
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
elif [[ "$1" == "-checkdatafilecount" ]]; then
######
#test parameters: qactl 1111 "2021-12-11 01:00:00" "2021-12-11 01:59:59"
#####
key="$2"
ip="$5"
start="$3"
end="$4"
hostid="$6"
cd /transient/ariel_proxy.ariel_proxy_server/data


echo INFO Checking related searches
for searchid in $(curl -k -S -X GET -H 'Range: items=0-100' -H 'Version: 16.0' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches" --header "SEC: $apitoken" 2>/dev/null |jq '.[]' |tr -d '"'); do
        #echo INFO checking $searchid
        grep $searchid /var/log/audit/audit.log |grep $key &>/dev/null
        if [[ $? -eq 0 ]]; then
                echo Related search detected $searchid
                grep $searchid /var/log/audit/audit.log |grep $key |awk '{ print $1" "$2" "$3}'
                grep $searchid /var/log/audit/audit.log |grep $key |grep -o 'AQL:.*'
                #echo RAW log:
                #grep $searchid /var/log/audit/audit.log |grep $key |awk '{ print $1" "$2" "$3}'
        fi
done
echo done.
echo
echo


if [[ "$hostid" == "" ]]; then
        echo INFO Performing search
        aql="select $key from events where sourceip='$ip' START '$start' STOP '$end'"
        echo Result:
        datafilecount="$(curl -k -S -X POST -H "SEC: $apitoken" -H 'Version: 16.0' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches" --data-urlencode "query_expression=$aql" 2>/dev/null | jq '.data_file_count')"
# increase HEAP size offline indexer
else
        echo CMD:
        echo Result:
        aql="select $key from events where sourceip='$ip' START '$start' STOP '$end' PARAMETERS REMOTESERVERS='$hostid'"
        datafilecount="$(curl -k -S -X POST -H "SEC: $apitoken" -H 'Version: 16.0' -H 'Accept: application/json' "https://$consoleip/api/ariel/searches" --data-urlencode "query_expression=$aql" 2>/dev/null | jq '.data_file_count')"

fi
echo
echo INFO dataFileCount is $datafilecount...
echo "$key;$aql;$datafilecount"
echo done.
fi
exit 0
