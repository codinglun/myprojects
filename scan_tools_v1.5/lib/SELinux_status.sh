#!/bin/bash
SE=$(/usr/sbin/sestatus | awk 'NR==1{print $3}')
echo $SE