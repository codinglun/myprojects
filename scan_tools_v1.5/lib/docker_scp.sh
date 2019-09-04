cfg_file=/opt/dragonball/config/box.cfg
DIR=/opt/dragonball/
LOCAL_IP=$(cat $cfg_file |grep local_ip|cut -d '=' -f 2)
DATABASE=$(docker ps|grep database|awk '{print $NF}'|tee /data/ball/dirmap/container_script/local_db)
ls -l ${DIR}config |grep device|awk '{print $9}'|cut -d '_' -f 2 > /tmp/docker_device_ips
NODE_NUM=$(cat /tmp/docker_device_ips | wc -l)

docker exec -ti $DATABASE /bin/bash -c "dd if=/dev/zero of=/tmp/scp_test bs=4k count=100000 conv=fdatasync" &> /dev/null
if [ $NODE_NUM -eq 1 ]; then
	docker exec -ti $DATABASE /bin/bash -c "/opt/dirmap/container_script/stand_alone.sh"
else
	docker exec -ti $DATABASE /bin/bash -c "/opt/dirmap/container_script/multi_machine.sh"
fi
