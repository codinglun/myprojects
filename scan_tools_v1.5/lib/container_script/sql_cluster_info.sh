#/bin/bash

mysql -uroot -plenovolabs -Ne 'show status'>/opt/dirmap/container_script/pscan
