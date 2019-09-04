#!/bin/bash
DATABASE=$(docker ps|grep database|awk '{print $NF}')

#echo -n  "未删除用户总数(status>-3):"
#docker exec -ti $DATABASE /bin/bash -c "/opt/dirmap/container_script/sql_user_backend_count.sh">/dev/null 2>&1
#cat /data/ball/dirmap/container_script/pscan

docker exec -ti $DATABASE /bin/bash -c "/opt/dirmap/container_script/sql_user_count.sh">/dev/null 2>&1
cat /data/ball/dirmap/container_script/pscan
echo -n "(包含已删除用户)"
