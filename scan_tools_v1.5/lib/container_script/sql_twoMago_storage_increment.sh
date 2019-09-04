
TWO_MONTH_AGO_DATE=$(date -d '-2 month' +%Y-%m)

mysql iris_v40 -uroot -plenovolabs -Ne "select total_space  from iris_space_stat_month where month='${TWO_MONTH_AGO_DATE}'"
