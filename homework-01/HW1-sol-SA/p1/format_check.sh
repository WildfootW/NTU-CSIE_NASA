#! /usr/bin/env bash

date_pattern='^([0-9]{4}-[0-9]{2}-[0-9]{2})|([0-9]{4}/[0-9]{2}/[0-9]{2})|([0-9]{4}\.[0-9]{2}\.[0-9]{2})$'
time_pattern="^[0-9]{2}:[0-9]{2}(:[0-9]{2})?$"

if [[ $1 =~ $date_pattern ]] && [[ $2 =~ $time_pattern ]]; then
	echo "$1 $2"
else
	echo "Invalid"
fi
