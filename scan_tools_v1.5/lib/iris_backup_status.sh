#!/bin/bash
CUR_MONTH=$(date +%b)
CUR_DAY=$(date +%e)
echo $CUR_DAY
BUCKUP=$(ls -l /data/ball/dirmap/database |awk '{if(NR>1){print "(",$(NF-3),$(NF-2),$NF,")"}}'|grep ${CUR_MONTH}|grep -w ${CUR_DAY})

if [ -z "${BUCKUP}" ];then
        echo "无今日备份"
else
        echo ${BUCKUP}

fi
