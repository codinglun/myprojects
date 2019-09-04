#!/bin/bash
mysql iris_v40 -uroot -plenovolabs -Ne 'select etime from iris_account'>/opt/dirmap/container_script/pscan
mysql iris_v40 -uroot -plenovolabs -Ne 'select space_limit,space_used,user_num_limit,user_num_used from iris_account_quota'>>/opt/dirmap/container_script/pscan
