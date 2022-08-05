#!/bin/bash
##
#[root@qradar ~]# /opt/qradar/bin/ariel_query
#--query option is required.
#
#Usage: arielquery.py [options]
#
#This script executes an ariel query, waits until it is complete, and prints the response to STDOUT.
#
#Example query: arielquery.py --output JSON --query "SELECT * FROM events" --verify_ca=CA_FILE_PATH
##

aql='select "payload" from events where (qid=28250254 AND userName='"'"apiuser"'"') LAST 24 HOURS'
for line in $(/opt/qradar/bin/ariel_query -f /opt/q-indexer/token -q "$aql" 2>/dev/null |grep -v Cursor | grep -v payload); do
        echo $line | base64 -d | sed -r 's#.+Params:Id:(.+), DB:.+#\1#'
done
