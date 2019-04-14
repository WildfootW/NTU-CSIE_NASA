#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019 WildfootW All rights reserved.
#

# option parser
OPTION_N=10
while [[ ! $# -eq 0 ]]; do
    key="$1"
    shift
    case $key in
        -n)
            if [[ ! $1 =~ ^-?[0-9]+$ ]] && [[ ! $1 =~ ^-?[0-9]+\.?[0-9]+$ ]]; then # if not a [10, -10, 10.5, -5.2]
                echo "Error: option requires an argument."
                exit 1
            elif [[ ! $1 =~ ^[0-9]+$ ]]; then # if not a positive integer
                echo "Error: line number must be positive integer."
                exit 1
            fi
            OPTION_N="$1"
            shift
            ;;
        *)
            if [[ $FILEPATH != "" ]] || [[ $key =~ ^-.*$ ]]; then
                echo "Usage: csie_analytics.sh [-n count] [filename]"
                exit 1
            fi
            FILEPATH="$key"
            if [[ ! -e $FILEPATH ]]; then
                echo "Error: log file does not exist."
                exit 1
            fi
            ;;
    esac
done
if [[ $FILEPATH == "" ]]; then
    echo "Usage: csie_analytics.sh [-n count] [filename]"
    exit 1
fi
#echo "OPTION_N = ${OPTION_N}"
#echo "FILEPATH = ${FILEPATH}"

result=`cat "$FILEPATH" | awk -v FS="(GET|POST) " '{ print $2 }' | awk -v FS="(\?| HTTP\/[0-9])" '{ print $1 }' | sort | uniq -c | sort -g -r -k 1`

declare -a path_list
declare -a query_times_list
total_query_times=0
while read -r line; do
    query_times=`echo $line | awk '{ print $1 }'`
    path_list+=(`echo $line | awk '{ print $2 }'`)
    query_times_list+=($query_times)
    total_query_times=$(($total_query_times+$query_times))
done <<< "$result"

printf "%-35s %-10s %s\n" "Path" "Times" "Percentage"
for((i = 0;i < ${#path_list[@]} && i < $OPTION_N;++i)); do
    percentage=`bc -l <<< "${query_times_list[$i]}*100/$total_query_times"`
    printf "%-35s %-10s %-2.2f%%\n" ${path_list[$i]} ${query_times_list[$i]} $percentage
done

