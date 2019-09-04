#!/bin/bash
function PATCH_INFO(){
	PATCH_DIR=/opt/dragonball/patch/
	#echo $PATCH_DIR
	cd ${PATCH_DIR} && ls -l | awk '{print $9}'>/tmp/patch.log
	for line in `cat /tmp/patch.log`;do
		cd ${PATCH_DIR}${line} && echo $line ":"; ls -l|awk '{print $9}'
	done
}
PATCH_INFO
