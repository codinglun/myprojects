#!/bin/bash

mysql iris_v40 -uroot -plenovolabs -Ne 'select count(*) from iris_team'>/opt/dirmap/container_script/pscan
