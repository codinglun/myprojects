#!/bin/bash
#grep 'core id' /proc/cpuinfo | sort -u | wc -l
 grep 'processor' /proc/cpuinfo | sort -u | wc -l
