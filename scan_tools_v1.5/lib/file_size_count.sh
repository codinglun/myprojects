#!/bin/bash
DATABASE=$(docker ps|grep database|awk '{print $NF}')


docker exec -ti $DATABASE /bin/sh -c "mysql $1 -uroot -plenovolabs -Ne 'select $2 from $3 '"| awk -F '|' NR==3'{print $2}'|cut -d ' ' -f 2

# | awk -F '|' NR==3'{print $2}'|cut -d ' ' -f 2
