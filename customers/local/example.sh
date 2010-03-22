#!/bin/expect 
source "/usr/local/expect_scripts/customers/local/header.tcl"
source "$crt_dir/ips/10.0.0.232.tcl"
set ::get_period 0
oracle
#set ret [get_apps_logs]
#set ret [get_unix_statistics 1]
set ret [launch_sqlplus]
puts $ret
