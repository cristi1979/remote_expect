#!/bin/expect
set crt_dir [file normalize [file dirname [info script]]]
source "$crt_dir/header.tcl"
source "$crt_dir/ips/41.223.208.35.tcl"
set ::get_period 0
#set ret [get_unix_statistics 1]
#set ret [get_apps_exceptions 1]
#set ret [get_apps_logs 1]
set ret [get_apps_statistics 10]
puts $ret

