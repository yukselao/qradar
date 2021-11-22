#!/bin/bash

year=$1
outputfile=/tmp/detect-1.out-$(hostname)
>$outputfile
function printusage(){
        echo 'Usage:
'$0' 2021 SourceIP

'

}
[[ -z "$year" ]] && echo "Year parameter not found" && printusage && exit 1

index=$2

export i=0
for param in $@; do
        export i="$(expr $i + 1)"
        [[ "$param" == "-d" ]] && debug="true"
done
for d in $(find /store/ariel/events/records/$year -type d -mindepth 3 -maxdepth 3 2>/dev/null); do
        du -sh $d/super/${index}~0 &>/dev/null
        if [ $? -ne 0 ]; then
                echo "$d/super/${index}~0;0"
                echo "$d/super/${index}~0;0" >> $outputfile
        else
                c=$(ls -1 $d/super/${index}~* 2>/dev/null |wc -l)
                if [[ "$c" -gt "1" ]]; then
                        if [[ "$debug" == "true" ]] && [[ "$c" -gt "1" ]]; then
                                echo "$d/super/${index}~0;$c;$(ls -1 $d/super/${index}~* |tr '\n' ',')"
                                echo "$d/super/${index}~0;$c;$(ls -1 $d/super/${index}~* |tr '\n' ',')" >> $outputfile
                        else
                                echo "$d/super/${index}~0;$c"
                                echo "$d/super/${index}~0;$c" >> $outputfile
                        fi
                fi
        fi
done
