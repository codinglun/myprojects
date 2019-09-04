#!/bin/bash
function disk_monitor()
{
TOTAL=0
COUNT=0
DISK_LOGS=/tmp/disk_logs
cd /var/log/sa && ls -l|grep 'sa[0-9]\{1,3\}'|awk '{print $NF}' > $DISK_LOGS
for line in `cat $DISK_LOGS`
do
	COUNT=$((${COUNT}+1))
	if [[ "$LANG" =~ "en" ]];then
					LOAD=$(sar -b -f $line|grep 'Average'|awk '{print $NF}')
	elif [[ "$LANG" =~ "zh" ]];then
					LOAD=$(sar -b -f $line|grep '平均'|awk '{print $NF}')
	fi
	TOTAL=$(awk -v x="$TOTAL" -v y="$LOAD" 'BEGIN{printf "%.2f",x+y}')
done
echo "平均每秒写入数据量:(块/s)"
AVG=$(awk -v x="$TOTAL" -v y="$COUNT" 'BEGIN{printf "%.2f",x/y}')
echo $AVG
cd - &> /dev/null
}
if [ -d /var/log/sa ];then
disk_monitor
else
echo "未安装sar"
fi

