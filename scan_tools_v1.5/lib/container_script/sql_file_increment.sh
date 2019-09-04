#!/bin/bash

CUR_YEAR=$(date +%Y)
CUR_MONTH=$(date -d '1 month ago' +%m)

mysql iris_v40 -uroot -plenovolabs -Ne "select count(DISTINCT path) from iris_version_entry where year(mtime)='${CUR_YEAR}' and month(mtime)='${CUR_MONTH}'">/opt/dirmap/container_script/pscan
