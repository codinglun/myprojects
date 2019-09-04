#!/bin/bash
connectivity=1
domain=$(/opt/dragonball/config/jcfg.py system/application/domain)
ping $domain -c 2 > /tmp/ping_app_domain
connectivity=$?
if [[ $connectivity == 0 ]];then
	ip=$(awk NR==1'{print $3}' /tmp/ping_app_domain)
	echo "通 , ${domain}${ip}"
else
	echo "不通 , ${domain}"
fi
