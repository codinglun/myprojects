#！/bin/bash
CUR_DIR=$(pwd)
RESULT_DIR=${CUR_DIR%%/lib*}/result
mount -l > ${RESULT_DIR}/mount.result
lsblk > ${RESULT_DIR}/lsblk.result
docker info > ${RESULT_DIR}/docker_info.result
top -b -n 1 > ${RESULT_DIR}/top_info.result
ifconfig > ${RESULT_DIR}/ifconfig.result
