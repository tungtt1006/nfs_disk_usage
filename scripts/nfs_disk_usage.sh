#!/bin/bash

currentpath=$(pwd)

if [ $1 = . ]; then
  path=$(pwd)
else
  path=$1
fi

# Functions

# Actions
array=($(ls -d $path/*/))

# Set up a metric file
echo "# HELP nfs_disk_usage_bytes The number of bytes usage" > /usr/share/nginx/metrics/metrics.txt

for i in ${array[@]}
do
  cd $i
  record="$(du -s)"
  bytes=$(echo "$record" | awk '{ print substr( $0, 1, length($0)-2 ) }')

  echo "nfs_disk_usage_bytes{volume=\"$i\"} $bytes" >> /usr/share/nginx/metrics/metrics.txt
done

cd $currentpath
