#!/bin/bash
CUR_YEAR=$(date +%Y)
CUR_MONTH=$(date +%m)
CUR_DAY=$(date +%d)

mysql iris_v40 -uroot -plenovolabs -Ne "select hour_23 from iris_space_stat_day where year(stat_date)='${CUR_YEAR}' and month(stat_date)='${CUR_MONTH}' and day(stat_date)=(${CUR_DAY}-1) and type=1 ">/opt/dirmap/container_script/pscan
