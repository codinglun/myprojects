#!/bin/bash
function MAX_REQ_INFO()
{
APPLICATION=$(docker ps|grep application|awk '{print $NF}')
if [ -z "$APPLICATION" ];then
        echo "当前服务器未部署application容器"
else
		TODAY=$(date +%d/%b)
		./lib/tools/logacc.py -f /data/ball/dirmap/application/log/nginx/bee.access.log|grep $TODAY|sort -t 't'  -k 3|sed '2,$d'>/tmp/pscan
fi
}
MAX_REQ_INFO

if [ -f /tmp/pscan ];then
    RES=$(cat /tmp/pscan)

    if [ -z "$RES" ];then
    	echo 0
    else
	echo "$RES"|awk '{print $4}'
    fi
fi
