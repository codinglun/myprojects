#!/bin/bash
function SQL_QUERY(){
	DATABASE=$(docker ps|grep database|awk '{print $NF}')
	file_size=$(docker exec -ti $DATABASE /bin/sh -c "mysql iris_v40 -uroot -plenovolabs -Ne 'select sum(bytes) from iris_file_info '"| awk -F '|' NR==3'{print $2}'|cut -d ' ' -f 2)
echo "file_size: $file_size"
bytes_to_MB=1048576
bytes_to_GB=1073741824
echo "bytes_to_GB : $bytes_to_GB"
file_sizeGB=`echo "sclae=2; $file_size/$bytes_to_MB" | bc`
#file_sizeGB=`expr $file_size / $bytes_to_GB`
echo "${file_size}GB"
}
SQL_QUERY
