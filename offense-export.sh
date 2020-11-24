#!/bin/bash
##
# e-mail: aliokan.yuksel@ibm.com
##


export quser="yuksela"
export qpassword="P@ssw0rd"
export starttime="$(date +%s000 -d '2020-11-24 09:20')"
export qradarip="172.16.123.11"
function downloadoffense() {
  folder="offense-$2-$3"
  mkdir -p $folder
  echo INFO Fetching $3 offense data...
  ppwd=$(pwd)
  curl -k -S -X GET -u "$quser:$qpassword" -H 'Range: items=0-50000' -H 'Version: 12.1' -H 'Accept: application/json' 'https://${qradarip}/api/siem/offenses?filter=domain_id%20%3D%20'"$1"'%20and%20start_time%3E'$2 -o offenses-$3.json
  ls -al offenses-$3.json
  cat offenses-$3.json |jq '.[] .description' |sort | uniq -c |sort -nr
  echo
}

# example: downloadoffense <domain-id> <start_time> <folder-prefix>
#folderprefix="mydomainname"
# 8: <domain-id>


folderprefix="mydomainname"
downloadoffense 8 $starttime mydomainname
#./generate-json.py offenses-${folderprefix}.json 50000 offense-${starttime}-${folderprefix}/ ResilientOrgName

