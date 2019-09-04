#!/bin/bash
#TODO:偶尔会抽风取不到数据！！！？？？？


DATABASE=$(docker ps|grep database|awk '{print $NF}')

ONE_MONTH_AGO_SPACE_BYTE=$(docker exec -it ${DATABASE} /bin/bash -c "/opt/dirmap/container_script/sql_oneMago_storage_increment.sh"|grep -v Using | awk '{if(FNR==2){print $2}}')

TWO_MONTH_AGO_SPACE_BYTE=$(docker exec -it ${DATABASE} /bin/bash -c "/opt/dirmap/container_script/sql_twoMago_storage_increment.sh"|grep -v Using | awk '{if(FNR==2){print $2}}')

if [ -z $ONE_MONTH_AGO_SPACE_BYTE ];then
        ONE_MONTH_AGO_SPACE_BYTE=0
fi

if [ -z $TWO_MONTH_AGO_SPACE_BYTE ];then
	TWO_MONTH_AGO_SPACE_BYTE=0
fi

INCREMENT_SPACE_BYTE=$((${ONE_MONTH_AGO_SPACE_BYTE}-${TWO_MONTH_AGO_SPACE_BYTE}))
if [ -z $INCREMENT_SPACE_BYTE ];then
	echo "${INCREMENT_SPACE_BYTE}MB"
else
	awk -v x="${INCREMENT_SPACE_BYTE}" -v y="1024" 'BEGIN{printf "%0.2f GB\n", x/(y*y*y)}'

fi
