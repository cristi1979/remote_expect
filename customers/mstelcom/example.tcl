#!/bin/expect
set crt_dir [file normalize [file dirname [info script]]]
source "$crt_dir/header.tcl"
source "$crt_dir/ips/41.72.61.22.tcl"
set ::get_period 0

set ret [get_apps_exceptions 1]
#set ret [get_apps_statistics]
#set ret [get_unix_statistics]
#set ret [get_apps_logs 10]
#set ret [get_apps]
puts $ret
