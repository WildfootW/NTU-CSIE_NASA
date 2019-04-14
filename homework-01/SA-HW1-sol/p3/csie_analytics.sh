#!/bin/bash

line=10
filename=$1

if [ -z "$1" ]; then
  echo "Usage: csie_analytics.sh [-n count] [filename]"
  exit 1
elif [[ "$1" =~ ^-.$ ]]; then  #to see if there is any option
  line=$2
  filename=$3
  if [ "$1" == "-n" ]; then
    if [ -z "$2" ]; then
      echo "Error: option requires an argument."
      exit 1
    elif [[ "$2" =~ ^[0-9]*[1-9][0-9]*$ ]]; then  #for simplicity, the regex can be "^[1-9]\d*$"
      if [ -z "$3" ]; then
        echo "Usage: csie_analytics.sh [-n count] [filename]"
        exit 1
      elif [ ! -f "$3" ]; then
        echo "Error: log file does not exist."
        exit 1
      fi
    else
      if [ -f "$2" ]; then
        echo "Error: option requires an argument."
        exit 1
      else
        echo "Error: line number must be positive integer."
        exit 1
      fi
    fi
  else
    echo "Usage: csie_analytics.sh [-n count] [filename]"
    exit 1
  fi
elif [ ! -f "$1" ]; then
  echo "Error: log file does not exist."
  exit 1
fi

result=$(awk '{print $5}' < $filename \
              | cut -d? -f1 \
              | sort | uniq -c | sort -nr)
total=$(echo "$result" | awk '{s+=$1} END {print s}')
printf "%-35s %-10s %-4s\n" "Path" "Times" "Percentage"
echo "$result" | awk -v total="$total" '{printf "%-35s %-10s %-2.2f%%\n", $2,$1,$1/total*100}' \
               | head -n "$line"
