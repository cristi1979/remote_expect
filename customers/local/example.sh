#!/usr/bin/expect 
set crt_dir [file normalize [file dirname [info script]]]
source "$crt_dir/header.tcl"
source "$crt_dir/ips/10.0.0.232.tcl"
set ::get_period 0
#set ::from_apps [list oracle]
#set ret [get_apps_logs]
#set ret [get_apps_statistics]
set ret [get_apps_exceptions]
#set ret [get_unix_statistics 2]
#set ret [launch_sqlplus]
puts $ret
