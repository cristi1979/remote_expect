#!/bin/expect
set crt_dir [file normalize [file dirname [info script]]]
source "$crt_dir/header.tcl"
source "$crt_dir/ips/10.0.20.66.tcl"
set emails [list "cristian.falcas@mindcti.com"]
set ret 0
set ::get_period 0
#set ret [get_unix_statistics 1]
set ret [get_apps_exceptions 10]
#set ret [get_apps_logs 1]
#set ret [get_apps]
#set ret [get_apps_statistics 1]
#set ret [exec_unix_statistics]
puts $ret

