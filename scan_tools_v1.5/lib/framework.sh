#!/bin/bash
output=/tmp/modules.txt
python ./lib/tools/jcfg.py device/iplist/all |sort|uniq >/tmp/.iplist
readlink /opt/dragonball > $output
while read line;do
        cd /opt/dragonball/config/device_$line/module
        echo "[$line]:" >> $output
        ls  >> $output
done</tmp/.iplist
sed -i "s/_.*//g" $output
cat $output
