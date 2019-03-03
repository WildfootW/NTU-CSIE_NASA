#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019 WildfootW All rights reserved.
#

#valid_date_split_char=("-" "/" ".")
valid_date_split_char=("-" "/" "\.") # mind grep regular expression
valid_time_split_char=(":")
valid_date_digit_number_0=(4 2 2)
valid_time_digit_number_0=(2 2 2)
valid_time_digit_number_1=(2 2)

if [ ! $# -eq 2 ]; then
    echo "Usage: ./format_check.sh [DATE] [TIME]"
    exit -1
fi

function check_format_sub()
{
    local -n origin_str=$1
    local -n valid_split_char=$2
    local -n valid_digit_number=$3
    #echo "$origin_str, ${valid_split_char[@]}, ${valid_digit_number[@]}"
    for symbol in ${valid_split_char[@]}; do
    #format_str="[0-9]{${valid_digit_number[0]}}"
    format_str="[0-9]\{${valid_digit_number[0]}\}"
        for index in $(seq 1 $((${#valid_digit_number[@]}-1))); do
            format_str+="$symbol"
            #format_str+="[0-9]{${valid_digit_number[$index]}}"
            format_str+="[0-9]\{${valid_digit_number[$index]}\}" # mind grep regular expression
        done
        #echo $format_str
        if [[ $origin_str = `echo $origin_str | grep -o $format_str` ]]; then
            #echo $origin_str | grep -o $format_str
            #echo "format $format_str success"
            return 1
        fi
    done
    return 0
}

time_origin=$2
date_origin=$1

check_format_sub date_origin valid_date_split_char valid_date_digit_number_0
date_ret_0=$?
check_format_sub time_origin valid_time_split_char valid_time_digit_number_0
time_ret_0=$?
check_format_sub time_origin valid_time_split_char valid_time_digit_number_1
time_ret_1=$?

if [ $date_ret_0 -eq 1 ]; then
    if [ $time_ret_0 -eq 1 ] || [ $time_ret_1 -eq 1 ]; then
        echo "$date_origin $time_origin"
        exit 0
    fi
fi
echo "Invalid"
exit 0
