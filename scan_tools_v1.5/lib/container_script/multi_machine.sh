#!/bin/bash

/opt/dirmap/config/jcfg.py device/namelist/database > /tmp/db_ips
local_db=$(cat /opt/dirmap/container_script/local_db)
rpm -i /opt/dirmap/container_script/expect_rpm/tcl-8.5.7-6.el6.x86_64.rpm /opt/dirmap/container_script/expect_rpm/expect-5.44.1.15-5.el6_4.x86_64.rpm &>/dev/null

while read line;do
	if [ "$local_db" == "$line" ];then
		continue
	fi
	
	echo -n "scp to $line" :
	/opt/dirmap/container_script/scp.sh /tmp/scp_test $line 22 lenovolabs | grep 100%|awk '{print $(NF-2)}'
done</tmp/db_ips

rm -rf /opt/dirmap/container_script/local_db
