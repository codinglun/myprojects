#!/bin/bash
function JVM_INFO(){
	JVMDIR=/opt/dragonball/base/application/resin.properties
	cat $JVMDIR | grep -w jvm_args|grep -v '#jvm'|cut -d ':' -f 2-
}
JVM_INFO