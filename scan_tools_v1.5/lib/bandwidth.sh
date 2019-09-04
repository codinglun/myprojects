#!/bin/bash
cfg_file=/opt/dragonball/config/box.cfg
LOCAL_IP=$(cat $cfg_file |grep local_ip|cut -d '=' -f 2)
net_card=$(ip route | grep $LOCAL_IP | cut -d ' ' -f 3)
#ENNAME=$(ifconfig|grep -i '^en'|awk '{print $1}'|tr -d ':')
ethtool $net_card|grep -i speed|cut -d ':' -f 2
