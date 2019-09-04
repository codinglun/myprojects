#!/bin/bash

RES=$(ps aux|grep sendmail|grep -v "grep")
if [ -z RES ]; then
	echo "关闭"
else
	echo "打开"

fi
