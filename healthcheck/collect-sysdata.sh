#!/bin/bash

cwd=$(pwd)
/bin/rm -fr /tmp/sysdata
function getepsdata() {
	cmd="cat /var/log/qradar.log |grep SourceMonitor |grep ecs-ec-ingress |grep -i 'incoming raw' |sed -r 's#^(.+?) ::.+ Peak in the last 60s: (.+? eps?)\. (Max Seen.+)#\1 Peak last 60s = \2#'"
	logdir=/tmp/sysdata/$1
	mkdir -p $logdir
	logfile=$logdir/peak-eps.log
	echo $(date "+%F %T") > $logfile
	echo $cmd >> $logfile
	echo "INFO run -> eval ssh $1 '$cmd'"
	eval ssh $1 "$cmd" &>> $logfile
	ret=$?
	if [ $ret -ne 0 ]; then
		echo "ERROR in cmd: eval ssh $1 '$cmd'" 
		
	fi
}

function getinfo() {
	logdir=/tmp/sysdata/$1
	cmd="$2"
	mkdir -p $logdir
	logfile=$logdir/$3
	echo $(date "+%F %T") > $logfile
	echo $cmd >> $logfile
	eval ssh $1 "$cmd" &>> $logfile
}




hosts=($(psql -U qradar -c "select ip from managedhost where status='Active'" -t |tr -d ' ' |grep -v "^$" | tr '\n' ' '))
for host in ${hosts[@]}; do
	echo getepsdata $host
	getepsdata $host
	getinfo $host "lscpu" "cpu-info.log"
	getinfo $host "lvs" "logical-volume-info.log"
	getinfo $host "df -h" "disk-usage.log"
	getinfo $host "free -g" "memory-usage.log"
	getinfo $host "iostat 1 10" "iostat.log"
	getinfo $host "/opt/qradar/bin/myver -v" "qradar-version.log"
	logdir=/tmp/sysdata/$1
	scp -r $host:/var/log/systemStabMon/$(date "+%Y/%m/%d") $logdir/stats-$(date "+%Y-%m-%d")
done


tar -pczf /tmp/sysdata.tgz /tmp/sysdata

du -sh /tmp/sysdata.tgz

echo Share this file with us
