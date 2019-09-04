#!/bin/bash
chkconfig --list 2>/dev/null|grep  boxcss|grep 3:on>/dev/null
res=$?
if [ $res == 0 ];then
	echo on
else
	echo off
fi
