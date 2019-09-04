#!/bin/bash
app_root=/opt/dragonball/
cfg_file=${app_root}config/box.cfg
local_ip=$(cat $cfg_file|grep local_ip|cut -d "=" -f 2)
if [ ! -d ./result ];then
	mkdir ./result
fi
chmod +x -R ./lib
if [ -d ${app_root} ];then
        #CUR_VERSION=$(cat $cfg_file | grep portal_root| awk -F ':' 'if($2>5 ){print "版本高于5.1.0.0";exit 1}' )
        a=$(cat /opt/dragonball/config/box.cfg | grep portal_root|cut -d '-' -f 2|cut -d '.' -f 1)
        b=$(cat /opt/dragonball/config/box.cfg | grep portal_root|cut -d '-' -f 2|cut -d '.' -f 2)
				version=$(cat /opt/dragonball/config/box.cfg | grep portal_root|cut -d '-' -f 2|cut -d '.' -f 1-4)
				echo -e "\n已安装网盘，当前版本 ${version}"
        if [ $a -gt 5 ];then
                echo 版本高于5.1.0.0,退出执行。
                exit 1
				elif [ $a -eq 5 ] && [ $b -gt 1 ];then
                echo 版本高于5.1.0.0,退出执行。
                exit 1
        fi
        echo "------------------------执行巡检模式------------------------"
				sar -u &> /dev/null
				if [ ! $? -eq 0 ]; then
					echo "系统未安装sar"
				fi
#复制容器中执行脚本到/data/ball/dirmap下
	if [ ! -d /data/ball/dirmap/container_script ];then
			mkdir -p /data/ball/dirmap/container_script
	fi
	cp -rf $(pwd)/lib/container_script/* /data/ball/dirmap/container_script/
#检查patrol_scan.conf | self_scan.conf 中指定的检查项(调用lib中对应的shell)，结果输出的result/xxx_scan.json
	echo -e "1.完整检查\n2.快速检查(无数据库查询)\n请输入巡检模式(1/2)：\n"
        while true
        do
            read num
            if [[ $num -eq 1 || $num -eq 2 ]];then
                break
            else
                echo -e "输入错误，请重新输入:\n"
            fi
        done
        if [[ $num -eq 1 ]];then
	    ./lib/box_scan.py ./config/patrol_scan.conf
        elif [[ $num -eq 2 ]];then
	    ./lib/box_scan.py ./config/patrol_scan_without_sql.conf
        fi
#将/var/log/message 和 sar拷贝到result/
	./lib/sys_msg.sh
#将mount lsblk 和 docker info 的结果输出到result/
	./lib/box_get_sys_config.sh
#将 mysql: show status like ‘ws%’的结果输出到result/
	./lib/mysql_show_status.sh
#将result打包
#echo $local_ip
	tar zcvf  ${local_ip}_result.tgz result > /dev/null 2>&1
	echo "巡检完成，结果输出到result/下"
else
	echo "-----------当前服务器未安装网盘，执行自检模式--------------"
	./lib/box_scan.py ./config/self_scan.conf
	echo "自检完成，结果输出到result/下"

fi
