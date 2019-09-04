#!/bin/bash


DATABASE=$(docker ps|grep database|awk '{print $NF}')

docker exec -ti $DATABASE /bin/sh -c "/opt/dirmap/container_script/sql_total_storage.sh">/dev/null 2>&1
SPACE_BYTE=$(cat /data/ball/dirmap/container_script/pscan)


awk -v x="${SPACE_BYTE}" -v y="1024" 'BEGIN{printf "%.2fGB\n", x/(y*y*y)}'
