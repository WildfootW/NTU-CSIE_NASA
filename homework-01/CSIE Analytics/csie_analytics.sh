#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019 WildfootW All rights reserved.
#

TMP_FILE_PATH="/tmp/.csie_analytics"

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

declare -A record_arr
total_query_times=0
while read line_origin; do
    path=`echo "$line_origin" | awk -v FS="(GET|POST) " '{ print $2 }' | awk -v FS="(\?| HTTP\/[0-9])" '{ print $1 }'`
    record_arr["$path"]=$((${record_arr["$path"]}+1))
    total_query_times=$((${total_query_times}+1))
done < $FILEPATH

declare -a answer_list
echo "" > "$TMP_FILE_PATH"
for key in "${!record_arr[@]}"; do
    percentage=`bc -l <<< "${record_arr[$key]}*100/$total_query_times"`
    printf "%-35s %-10s %-2.2f%%\n" $key ${record_arr[$key]} $percentage >> "$TMP_FILE_PATH"
    #answer+=(`printf "%-35s %-10s %-2.2f%%\n" $key ${record_arr[$key]} $percentage`)
done
printf "%-35s %-10s %s\n" "Path" "Times" "Percentage"
cat "$TMP_FILE_PATH" | sort -g -r -k 2 | head -n $OPTION_N
rm "$TMP_FILE_PATH"
#printf "%s" "${answer[@]}" | sort -g -k 2
