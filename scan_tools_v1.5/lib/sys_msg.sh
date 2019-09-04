#!/bin/bash
RESULT_DIR=$(pwd)/result
if [ ! -d ${RESULT_DIR}/var_log_messages.result/ ];then
	mkdir -p ${RESULT_DIR}/var_log_messages.result/
fi

cp -rf /var/log/messages* ${RESULT_DIR}/var_log_messages.result/
if [ -d "/var/log/sa" ];then
	if [ ! -d ${RESULT_DIR}/sa_log  ];then
			mkdir -p ${RESULT_DIR}/sa_log
		fi
		cp -rf /var/log/sa/*  ${RESULT_DIR}/sa_log/
fi
