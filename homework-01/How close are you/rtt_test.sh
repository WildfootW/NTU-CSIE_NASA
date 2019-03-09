#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019 WildfootW All rights reserved.
#

if [ ! $# -eq 1 ]; then
    echo "Usage ./rtt_test.sh [FILE]"
    exit -1
fi

get_ave_round_trip_time()
{
    local -n local_domain_name=$1
    local -n local_ave_time=$2
    local_ave_time=`ping -c 3 -q $local_domain_name 2> /dev/null | awk -v FS="mdev = " '{ print $2 }' | awk -v FS="/" 'NF { print $1 }'` # NF for ignore empty lines
}

FILEPATH="$1"
#cat "$FILEPATH"

all_result=""
while read line_origin; do
    line_header=`echo "$line_origin" | awk '{ print $1 }'`
    #echo "$line_header"
    if [[ "$line_header" = "" ]]; then
        continue
    elif [ "$line_header" = "##" ]; then
        continue
    elif [ "$line_header" = "#Server" ]; then
        server_domain=`echo "$line_origin" | awk '{ print $3 }'`
        ave_time=""
        get_ave_round_trip_time server_domain ave_time
        if [[ "$ave_time" != "" ]]; then
            # [TODO] this method seems stupid and their will have a empty line at the begging
            all_result="$all_result$server_domain $ave_time\n"
            #all_result=`printf "%s%s %s\n" "$all_result" "$server_domain" "$ave_time"`
            #printf "%s" "$all_result"
        fi
    fi
done < $FILEPATH

# [TODO] this method seems stupid and their will have a empty line at the begging
all_result=`echo -e "$all_result" | sort -g -k 2`
echo "$all_result"
