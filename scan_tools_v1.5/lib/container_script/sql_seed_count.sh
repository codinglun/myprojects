#!/bin/bash

mysql  gamma -uroot -plenovolabs -Ne 'select count(*) from gamma_object'>/opt/dirmap/container_script/pscan
