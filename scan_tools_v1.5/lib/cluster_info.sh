#!/bin/bash

DATABASE=$(docker ps|grep database|awk '{print $NF}')
docker exec -it $DATABASE /bin/bash -c '/opt/dirmap/container_script/sql_cluster_info.sh' >/dev/null 2>&1
cat /data/ball/dirmap/container_script/pscan|grep wsrep_cluster_size|awk '{print $2}'
