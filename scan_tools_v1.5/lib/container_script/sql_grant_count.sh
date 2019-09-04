#!/bin/bash

mysql iris_v40 -uroot -plenovolabs -Ne 'select count(*) from iris_auth_grant_entry'>/opt/dirmap/container_script/pscan
