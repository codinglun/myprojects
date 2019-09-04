#!/bin/bash
DATABASE=$(docker ps|grep database|awk '{print $NF}')


docker exec -ti $DATABASE /bin/sh -c "/opt/dirmap/container_script/sql_team_count.sh">/dev/null 2>&1
cat /data/ball/dirmap/container_script/pscan

