#!/bin/bash
DATABASE=$(docker ps|grep database|awk '{print $NF}')

docker exec -it $DATABASE /bin/bash -c "/opt/dirmap/container_script/show_status.sh" > ./result/mysql_show_status
