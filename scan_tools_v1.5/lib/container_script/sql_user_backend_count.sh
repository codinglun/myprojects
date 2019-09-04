#!/bin/bash
mysql iris_v40 -uroot -plenovolabs -Ne 'select count(*)-2 from iris_user where status>-3'>/opt/dirmap/container_script/pscan
