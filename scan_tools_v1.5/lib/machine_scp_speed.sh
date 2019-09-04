#!/bin/bash

function SCP_SPEED(){
	cfg_file=/opt/dragonball/config/box.cfg
	APP_DIR=/opt/dragonball/
	LOCAL_IP=$(cat $cfg_file |grep local_ip|cut -d '=' -f 2)
	ls -l ${APP_DIR}config |grep device|awk '{print $9}'|cut -d '_' -f 2 > /tmp/device_ips
	NODE_NUM=$(cat /tmp/device_ips | wc -l)
	if [ $NODE_NUM -eq 1 ]; then
		echo "当前单台部署，不能测机器间scp"
	else
	  if [ ! -f "/tmp/scp_test" ];then
			dd if=/dev/zero of=/tmp/scp_test bs=4k count=10000 conv=fdatasync &>/dev/null
		fi
		while read line;do
			 if [ "$LOCAL_IP" == "$line" ];then
				continue
			 fi
			 echo "$LOCAL_IP to $line :"
			 passwd=$(./lib/tools/jcfg.py device/password lenovolabs $line)
			 ${APP_DIR}tools/scp.sh /tmp/scp_test $line 22 ${passwd}|grep 100%|awk '{print  $(NF-2)}'
		done</tmp/device_ips
	fi
}
SCP_SPEED
