#!/bin/bash

function net_monitor()
{
TOTAL=0
COUNT=0
NET_LOGS=/tmp/memory_logs
cd /var/log/sa && ls -l|grep 'sa[0-9]\{1,3\}'|awk '{print $2}' > $NET_LOGS
for line in `cat $NET_LOGS`
do
	COUNT=$((${COUNT}+1))
	COUNT=$((${COUNT}+1))
	if [[ "$LANG" =~ "en" ]];then
					LOAD=$(sar -r -f $line|grep 'Average'|awk '{print $NF}')
	elif [[ "$LANG" =~ "zh" ]];then
					LOAD=$(sar -r -f $line|grep 'Average'|awk '{print $NF}')
	fi
	TOTAL=$(awk -v x="$TOTAL" -v y="$LOAD" 'BEGIN{printf "%.2f",x+y}')
done
echo "平均套接字使用次数:"
AVG=$(awk -v x="$TOTAL" -v y="$COUNT" 'BEGIN{printf "%.2f",x/y}')
echo $AVG
cd - &> /dev/null
}
if [ -d /var/log/sa ];then
net_monitor
else
echo "未安装sar"
fi

