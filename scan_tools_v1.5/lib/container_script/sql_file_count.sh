#!/bin/bash

mysql iris_v40 -uroot -plenovolabs -Ne 'select count(*) from iris_file_info '>/opt/dirmap/container_script/pscan
