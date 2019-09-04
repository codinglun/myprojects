#!/bin/bash
EXIST=$(df -h|grep -w $1)
if [ -z "$EXIST" ]; then
        echo "未分配${1}分区"
else
        size=$(echo $EXIST|awk '{printf $2}')
        used=$(echo $EXIST|awk '{printf $5}')
        dd if=/dev/zero of=$1/testwrite bs=4k count=100000 conv=fdatasync  > /tmp/disk_result.txt 2>&1
        speed=$(cat /tmp/disk_result.txt|awk -F, NR==3'{print $NF}')
        rm -f $1/testwrite
        date=$(date +"%Y-%m-%d %H:%m:%S")
        #echo -e "{\n\"检查项\"：\"分区空间使用\",\n\"tool\":\"disk.sh\",\n\"ctime\":\"$date\",\n\"result\":\n{\n\"size\":\"$size\",\"used%\":\"$used\",\"speed\":\"$speed\"\n}"
        echo -e "$1 $size $used $speed"
fi