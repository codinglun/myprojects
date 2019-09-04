#!/bin/bash

mysql iris_v40 -uroot -plenovolabs -Ne 'select count(*) from iris_journal_entry'>/opt/dirmap/container_script/pscan
