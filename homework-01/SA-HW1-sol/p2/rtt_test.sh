#!/bin/bash

IFS=$'\n'
if [ -z $1 ]; then
  echo "Usage: rtt_test.sh[FILE]"
  exit 1
fi
for entry in $(grep Server $1 | awk -F'= ' '{print $2}'); do
  time=$(ping -c 3 -q "$entry" 2> /dev/null | grep round-trip | cut -d / -f 5)
  if [ -z "$time" ]; then
    continue;
  fi
  echo "$entry $time"
done | sort -g -k 2
