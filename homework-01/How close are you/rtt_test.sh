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

ave_round_trip_time()
{
    local -n domain_name=$1
    echo `ping -c 3 -q $domain_name`
}

FILEPATH="$1"
#cat "$FILEPATH"

while read line_origin; do
    line_header=`echo "$line_origin" | awk '{ print $1 }'`
    #echo "$line_header"
    if [[ "$line_header" = "" ]]; then
        continue
    elif [ "$line_header" = "##" ]; then
        continue
    elif [ "$line_header" = "#Server" ]; then
        server_domain=`echo "$line_origin" | awk '{ print $3 }'`
        ave_round_trip_time server_domain
    fi
done < $FILEPATH
