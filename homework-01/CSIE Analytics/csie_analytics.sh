#!/usr/bin/env bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019 WildfootW All rights reserved.
#

# Absolute path to this script, e.g. /home/user/Pwngdb/install.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/Pwngdb
SCRIPTPATH=$(dirname "$SCRIPT")

# option parser
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
            if [[ $FILE != "" ]] || [[ $key =~ ^-.*$ ]]; then
                echo "Usage: csie_analytics.sh [-n count] [filename]"
                exit 1
            fi
            if [[ ! -f $FILE ]]; then
                echo "Error: log file does not exist."
                exit 1
            fi
            FILE="$key"
            ;;
    esac
done
if [[ $FILE == "" ]]; then
    echo "Usage: csie_analytics.sh [-n count] [filename]"
    exit 1
fi
echo "OPTION_N = ${OPTION_N}"
echo "FILE     = ${FILE}"

