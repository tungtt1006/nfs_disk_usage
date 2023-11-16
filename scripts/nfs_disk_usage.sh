#!/bin/bash

if [ ! -d "$1" ]; then
  echo "No such file or directory"
  exit
fi

# List directories
directories=($(ls -d $1/*/))

# Set up a metric file
echo "# HELP nfs_disk_usage_bytes The number of bytes usage" > test.txt
echo "# TYPE nfs_disk_usage_bytes gauge" >> test.txt

for i in ${directories[@]}
do
  record="$(du -s -b $i)"
  bytes=$(awk -F' ' '{print $1}' <<< $record)

  echo "nfs_disk_usage_bytes{volume=\"$i\"} $bytes" >> test.txt
done

# Push to pushgateway
curl --data-binary @test.txt http://<pushgateway>:9091/metrics/job/nfs_disk_usage
