#!/bin/bash
DATABASE=$(docker ps|grep database|awk '{print $NF}')
docker exec -ti $DATABASE /bin/sh -c "/opt/dirmap/container_script/sql_license.sh">/dev/null 2>&1
etime=$(awk NR==1'{print $0}' /data/ball/dirmap/container_script/pscan)
space_limit=$(awk NR==2'{print $1/1024/1024/1024}' /data/ball/dirmap/container_script/pscan)
space_used=$(awk NR==2'{print $2/1024/1024/1024}' /data/ball/dirmap/container_script/pscan)
user_num_limit=$(awk NR==2'{print $3}' /data/ball/dirmap/container_script/pscan)
user_num_used=$(awk NR==2'{print $4}' /data/ball/dirmap/container_script/pscan)

echo -e "网盘到期时间:$etime,授权空间:${space_limit} GB,已用空间:${space_used} GB,授权人数:${user_num_limit},已用人数:${user_num_used}"
