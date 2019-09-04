#!/bin/bash

CUR_YEAR=$(date +%Y)
CUR_MONTH=$(date -d '1 month ago' +%m)

mysql iris_v40 -uroot -plenovolabs -Ne "select count(*) from iris_cursor where year(ctime)='${CUR_YEAR}' and month(ctime)='${CUR_MONTH}'">/opt/dirmap/container_script/pscan
