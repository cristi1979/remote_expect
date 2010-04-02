#!/bin/expect
set crt_dir [file normalize [file dirname [info script]]]
source "$crt_dir/header.tcl"
source "$crt_dir/ips/10.0.20.21.tcl"
set ret 0
set ::get_period 0
set ret [get_unix_statistics 15]
#set ret [get_apps_exceptions 20]
#set ret [get_apps_logs 1]
#set ret [get_apps_statistics 10]
#set ret [exec_unix_statistics]
puts $ret

