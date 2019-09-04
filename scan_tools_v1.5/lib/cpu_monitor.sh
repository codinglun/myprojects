#!/bin/bash
function CPU_LOAD() {
	TOTAL=0
	COUNT=0
	CPU_LOGS=/tmp/cpu_logs
	cd /var/log/sa && ls -l|grep 'sa[0-9]\{1,3\}'|awk '{print $NF}' > $CPU_LOGS
	for line in `cat $CPU_LOGS`
	do
	         COUNT=$((${COUNT}+1))
					if [[ "$LANG" =~ "en" ]];then
									LOAD=$(sar -q -f $line|grep 'Average'|awk '{print $4}')
					elif [[ "$LANG" =~ "zh" ]];then
									LOAD=$(sar -q -f $line|grep '平均'|awk '{print $4}')
					fi
	 	 TOTAL=$(awk -v x="$TOTAL" -v y="$LOAD" 'BEGIN{printf "%.2f",x+y}')
	done
	AVG=$(awk -v x="$TOTAL" -v y="$COUNT" 'BEGIN{printf "%.2f",x/y}')
	echo $AVG
	cd - &> /dev/null
}
if [ -d /var/log/sa ];then
CPU_LOAD
else
echo "未安装sar"
fi
