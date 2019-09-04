#!/bin/bash
DATABASE=$(docker ps|grep database|awk '{print $NF}')


docker exec -ti $DATABASE /bin/sh -c "/opt/dirmap/container_script/sql_grant_count.sh"|grep -v Using | awk '{if(FNR==2){print $2}}'>/dev/null 2>&1
cat /data/ball/dirmap/container_script/pscan

