#!/bin/bash

runningFile=/root/metrics-running.txt

mkdir -p $METRICS_FILE_PATH

if [ -f $runningFile ]; then
  exit # File exists, which means prev execution has not completed.
else
  if [ $1 = . ]; then
    path=$(pwd)
  else
    path=$1
  fi

  # Actions
  array=($(ls -d $path/*/))

  # Set up a metric file
  echo "# HELP nfs_disk_usage_bytes The number of bytes usage" > $runningFile
  echo "# TYPE nfs_disk_usage_bytes gauge" >> $runningFile

  for i in ${array[@]}
  do
    cd $i
    record="$(du -s -b)"
    bytes=$(echo "$record" | awk '{ print substr( $0, 1, length($0)-2 ) }')

    echo "nfs_disk_usage_bytes{volume=\"$i\"} $bytes" >> $runningFile
  done

  mv $runningFile $METRICS_FILE_PATH/metrics.txt
fi
