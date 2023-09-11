#!/bin/bash

currentPath=$(pwd)

if [ $1 = . ]; then
  path=$(pwd)
else
  path=$1
fi

# Actions
array=($(ls -d $path/*/))

# Set up a metric file
metricFilepPath="$METRICS_FILE_PATH/metrics.txt"
mkdir -p $METRICS_FILE_PATH
echo "# HELP nfs_disk_usage_bytes The number of bytes usage" > $metricFilepPath
echo "# TYPE nfs_disk_usage_bytes gauge" >> $metricFilepPath

for i in ${array[@]}
do
  cd $i
  record="$(du -s)"
  bytes=$(echo "$record" | awk '{ print substr( $0, 1, length($0)-2 ) }')

  echo "nfs_disk_usage_bytes{volume=\"$i\"} $bytes" >> $metricFilepPath
done

cd $currentPath
