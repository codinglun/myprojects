#!/bin/bash
APPLICATION=$(docker ps|grep application|awk '{print $NF}')
if [ -z "$APPLICATION" ];then
	echo "当前服务器未部署application容器"
else
	docker exec -ti $APPLICATION /bin/sh -c "cat /opt/srv/resin/conf/box.properties|grep version.internal|cut -d '=' -f 2"
fi
