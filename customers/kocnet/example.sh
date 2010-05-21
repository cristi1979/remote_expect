#!/usr/bin/expect 
set crt_dir [file normalize [file dirname [info script]]]
source "$crt_dir/header.tcl"
source "$crt_dir/ips/195.87.82.135.tcl"
set ::get_period 0
#set_skip rtsserver [list log1 greps snoop "lib/batik-all*"]
#set ::from_apps [list oracle]
#myhash -delnode ::applications_array "$::str_app_logs,*,server"
#set ret [get_apps_logs 10]
#set ret [get_apps]
#set ret [get_apps_statistics ]
set ret [get_apps_exceptions 1]
#set ret [get_unix_statistics 1] 
#set ret [get_system_audit]
#catch {set ret [get_system_audit]} res
#if {![string is integer -strict $res]} { puts "\n\tERR: $res"; set ret 1 }.
#set ret [launch_sqlplus]
#set ret [exec_unix_statistics]
puts $ret
