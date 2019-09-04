#!/bin/bash
function memory_monitor()
{
TOTAL=0
COUNT=0
MEMORY_LOGS=/tmp/memory_logs
cd /var/log/sa && ls -l|grep 'sa[0-9]\{1,3\}'|awk '{print $NF}' > $MEMORY_LOGS
for line in `cat $MEMORY_LOGS`
do
	COUNT=$((${COUNT}+1))
	if [[ "$LANG" =~ "en" ]];then
					LOAD=$(sar -r -f $line|grep 'Average'|awk '{print $4}')
	elif [[ "$LANG" =~ "zh" ]];then
					LOAD=$(sar -r -f $line|grep '平均'|awk '{print $4}')
	fi
	TOTAL=$(awk -v x="$TOTAL" -v y="$LOAD" 'BEGIN{printf "%.2f",x+y}')
done
echo "平均内存使用率:(%)"
AVG=$(awk -v x="$TOTAL" -v y="$COUNT" 'BEGIN{printf "%.2f",x/y}')
echo $AVG
cd - &> /dev/null
}
if [ -d /var/log/sa ];then
memory_monitor
else
echo "未安装sar"
fi

