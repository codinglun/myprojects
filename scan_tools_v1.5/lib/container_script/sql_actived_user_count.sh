#!/bin/bash


mysql iris_v40 -uroot -plenovolabs -Ne 'select count(DISTINCT uid) from iris_session'>/opt/dirmap/container_script/pscan
