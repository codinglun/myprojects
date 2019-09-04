#! /usr/bin/expect -f 
set timeout 3000
set File [lindex $argv 0] 
set Host [lindex $argv 1] 
set Port [lindex $argv 2] 
set Pass [lindex $argv 3] 
spawn scp -r -P $Port $File root@$Host:$File
expect {
"yes/no" { send "yes\r"; exp_continue}
"password:" { send "$Pass\r" }
}
expect eof
