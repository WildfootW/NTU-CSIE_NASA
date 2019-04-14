#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019 WildfootW All rights reserved.
#

excution_file="./csie_analytics.sh"

echo -e "\n> Error: option requires an argument."
"$excution_file" -n log.txt

echo -e "\n> Error: line number must be positive integer."
"$excution_file" -n -10.2 log.txt

echo -e "\n> Error: log file does not exist."
"$excution_file" -n 10 xxx.xxx

echo -e "\n> Usage: csie_analytics.sh [-n count] [filename]"
"$excution_file" -q log.txt
"$excution_file"
"$excution_file" -n 10

echo -e "\n> normal case:"
echo "$excution_file log.txt"
"$excution_file" log.txt

echo -e "\n> normal case:"
echo "$excution_file -n 2 log.txt"
"$excution_file" -n 2 log.txt
