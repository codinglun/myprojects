#!/bin/bash
function VERSION_INFO(){
	VERSIONDIR=/opt/dragonball/config
	cat $VERSIONDIR/box.cfg |grep portal_root | cut -d '-' -f 2| cut -d '.' -f 1-4
}
VERSION_INFO