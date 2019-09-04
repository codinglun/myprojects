#!/bin/bash

APP_ID=$(/opt/dirmap/config/jcfg.py device/namelist/application)

rpm -i /opt/dirmap/container_script/expect_rpm/tcl-8.5.7-6.el6.x86_64.rpm /opt/dirmap/container_script/expect_rpm/expect-5.44.1.15-5.el6_4.x86_64.rpm &>/dev/null

/opt/dirmap/container_script/scp.sh /tmp/scp_test ${APP_ID} 22 lenovolabs | grep '100%'|awk '{print $(NF-2)}'
