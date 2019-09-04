#!/bin/bash
mount |grep -w "xfs">/tmp/file_type
if [ $?=0 ];then
	echo "存在xfs类型的磁盘"
	cat /tmp/file_type
else
	echo "所有磁盘都是 ext4"
fi
