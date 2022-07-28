#!/bin/bash

if [[ -z "$1" ]]; then
        echo 'Usage:
'$0' /store/ariel/detect-1.sh /root/

'
        exit 1

hostlist=(xlogep01 xlogdn01 xlogdn02)

for h in ${hostlist[@]}; do

        echo scp $1 $h:$2
        scp $1 $h:$2
        echo
        echo
done
