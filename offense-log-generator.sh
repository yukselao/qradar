#!/bin/bash
cd /root/20210505
token=/root/20210505/token.txt

users=(ali.okan caadmin ozer)

for username in ${users[@]}; do
	aql="select username, Filenet_date2 from events where logSourceId in ('21966') or (logSourceId='21967') or (logSourceId='22483') or (logSourceId='22484') or (logSourceId='23265') or (logSourceId='23266') AND ( icu4jsearch('/jaxrs/logon', payload) "'!'"= -1 AND icu4jsearch('""$username""', payload) "'!'"= -1 ) order by Filenet_date2  desc LIMIT 1 last 5 MINUTES"
	#echo INFO $aql
	export login="$(/opt/qradar/bin/ariel_query -o CSV -f $token -q "$aql" |grep -v username |tr -d '\n')"
	export loginhash="$(echo $login |md5sum)"
	echo "webshere login detected-test $login $loginhash" > ${username}.log
	cat ${username}.log 2>/dev/null |grep $username
	if [[ $? -eq 0 ]] && [[ "$(grep "$login" ${username}.logsent |wc -l)" -eq 0 ]]; then
			echo $login $loginhash >> ${username}.logsent
			echo /opt/qradar/bin/logrun.pl -d 10.240.65.120 -p 514 -t -u 9.9.9.9 -f ${username}.log 1
			/opt/qradar/bin/logrun.pl -d 10.240.65.120 -p 514 -t -u 9.9.9.9 -f ${username}.log 1
			echo $(date)" INFO Log sent successfully $login"
	else
		echo $(date)" INFO We already sent a log about this event or no event detected in selected time period $username"	
	fi
done 
