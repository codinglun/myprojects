#!/bin/bash
info=$(df -T -h | awk 'NR==2{print $0}')
space=$(echo $info | awk 'NR==1{print $3}')
echo $space