#!/bin/bash

for d in $(find events/records -type d -mindepth 4 -maxdepth 4 2>/dev/null); do
        du -sh $d/super/SourceIP~0 &>/dev/null
        if [ $? -ne 0 ]; then
                echo "$d/super/SourceIP~0 doesn't exists"
        else
                c=$(ls -1 $d/super/SourceIP~* 2>/dev/null |wc -l)
                if [[ "$c" -gt "1" ]]; then
                        echo "$d/super/SourceIP~0 duplucate file | $(ls -1 $d/super/SourceIP~* 2>/dev/null |tr '\n' ', ')"
                fi
        fi
done
