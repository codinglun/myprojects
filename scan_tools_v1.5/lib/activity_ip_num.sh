#!/bin/bash

APPLICATION=$(docker ps|grep application|awk '{print $NF}')
if [ -z "$APPLICATION" ];then
        echo "当前服务器未部署application容器"
else
	 ./lib/tools/logacc.py -f /data/ball/dirmap/application/log/nginx/bee.access.log|grep ACTIVED_IP|awk '{print $2}'
fi
