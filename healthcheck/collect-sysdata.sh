#!/bin/bash

cwd=$(pwd)
/bin/rm -fr /tmp/sysdata

function isconsole() {
	test $(ip addr list |grep -F $1  2>/dev/null|wc -l) -gt 0
	if [ $? -eq 0 ]; then
		echo "true"
	else
		echo "false"
	fi	
}


function getepsdata() {
	cmd="cat /var/log/qradar.log |grep SourceMonitor |grep ecs-ec-ingress |grep -i 'incoming raw' |sed -r 's#^(.+?) ::.+ Peak in the last 60s: (.+? eps?)\. (Max Seen.+)#\1 Peak last 60s = \2#'"
	logdir=/tmp/sysdata/$1
	mkdir -p $logdir
	logfile=$logdir/peak-eps.log
	echo $(date "+%F %T") > $logfile
	echo $cmd >> $logfile
	echo "INFO run -> eval ssh $1 '$cmd'"
	if [[ "$(isconsole $1)" == "true" ]]; then
		echo "INFO run local cmd eval '$cmd'"
		eval "$cmd" &>> $logfile
	else
		eval ssh -o StrictHostKeyChecking=no $1 "$cmd" &>> $logfile
		ret=$?
		if [ $ret -ne 0 ]; then
			echo "ERROR in cmd: eval ssh $1 '$cmd'" 
		fi
	fi
}

function getinfo() {
	logdir=/tmp/sysdata/$1
	cmd="$2"
	mkdir -p $logdir
	logfile=$logdir/$3
	echo $(date "+%F %T") > $logfile
	echo $cmd >> $logfile
	if [[ "$(isconsole $1)" == "true" ]]; then
		echo "INFO run local cmd eval '$cmd'"
		eval "$cmd" &>> $logfile
	else
		eval ssh -o StrictHostKeyChecking=no $1 "$cmd" &>> $logfile
	fi
}



hosts=($(psql -U qradar -c "select ip from managedhost where status='Active'" -t |tr -d ' ' |grep -v "^$" | tr '\n' ' '))
for host in ${hosts[@]}; do
	echo INFO collecting EPS data...
	getepsdata $host
	echo INFO collecting CPU info...
	getinfo $host "lscpu" "cpu-info.log"
	echo INFO collecting volume information...
	getinfo $host "lvs" "logical-volume-info.log"
	echo INFO collecting disk usage information...
	getinfo $host "df -h" "disk-usage.log"
	echo INFO collecting memory information...
	getinfo $host "free -g" "memory-usage.log"
	echo INFO collecting qradar version information...
	getinfo $host "/opt/qradar/bin/myver -v" "qradar-version.log"
	logdir=/tmp/sysdata/$host
	echo INFO collecting systemStabMon information for today...
	if [[ "$(isconsole)" == "true" ]]; then
		/bin/cp -r $host:/var/log/systemStabMon/$(date "+%Y/%m/%d") $logdir/stats-$(date "+%Y-%m-%d")
	else
		echo scp -o StrictHostKeyChecking=no -r $host:/var/log/systemStabMon/$(date "+%Y/%m/%d") $logdir/stats-$(date "+%Y-%m-%d")
		scp -o StrictHostKeyChecking=no -r $host:/var/log/systemStabMon/$(date "+%Y/%m/%d") $logdir/stats-$(date "+%Y-%m-%d")
	fi
	echo done.
done


tar -pczf /tmp/sysdata.tgz /tmp/sysdata

du -sh /tmp/sysdata.tgz

echo Share this file with us
