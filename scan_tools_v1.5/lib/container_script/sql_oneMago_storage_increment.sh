#!/bin/bash

ONE_MONTH_AGO_DATE=$(date -d '-1 month' +%Y-%m)


mysql iris_v40 -uroot -plenovolabs -Ne "select total_space  from iris_space_stat_month where month='${ONE_MONTH_AGO_DATE}'"
