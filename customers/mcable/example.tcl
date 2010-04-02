#!/bin/expect 
set crt_dir [file normalize [file dirname [info script]]]
source "$crt_dir/header.tcl"
source "$crt_dir/ips/200.52.193.223.tcl"
set ::get_period 0
set ::from_apps [list udrserver apiserver]
set_skip udrserver [list CDRs2Export Cdrs2Export nohup.out JBOSS_old {"e:\cdr de prueba\"}]
set ret 0
#set ret [exec_unix_statistics]
#test
#set ret [get_apps_exceptions 8]
set ret [get_apps_statistics 8]
#set ret [get_unix_statistics 1]
#set ret [get_apps_logs]
#set ret [get_apps]
puts $ret
