#!/bin/expect
set crt_dir [file normalize [file dirname [info script]]]
source "$crt_dir/header.tcl"
source "$crt_dir/ips/200.52.193.222.tcl"
set ::get_period 0

set ::from_apps [list tomcat]
#set ::from_apps [list sipmanagement]
#parray ::applications_array
#myhash -getnode ::applications_array "$::str_app_logs,/u01/mind/mindcti/engine"
#myhash -getnode ::applications_array "$::str_app_logs,/u01/mind/cdr,log,CollectorInfo" cdrcollector
#myhash -delnode ::applications_array "$::str_app_logs,/u01/mind/mindcti/engine,syslog,radius"
#parray ::applications_array
#parray ::tmp_array
#exit
#set_skip cdrcollector [list cdr_2_process cdr_2_process_rts2]
#set ::from_apps [list cdrcollector cdrprocessor]
#myhash -delnode ::applications_array "$::str_app_logs,*/engine,syslog,radius"
#myhash -delnode ::applications_array "$::str_app_logs,*/engine,syslog,media"
#myhash -delnode ::applications_array "$::str_app_logs,*/engine,syslog,syslog"
#myhash -delnode ::applications_array "$::str_app_logs,*/engine,syslog,trace"
#myhash -delnode ::applications_array "$::str_app_logs,/u01/mind/mindcti/engine,syslog,trace"
set ret 0
#set ret [exec_unix_statistics]
#test
#set res [list]
#catch {set ret [get_apps_exceptions]} res
#catch {set ret [get_system_audit]} res

#if {![string is integer -strict $res]} { puts "\n\tERR: $res"; set ret 1 } 
#set_skip udrserver [list CDRs2Export Cdrs2Export nohup.out JBOSS_old {"e:\cdr de prueba\"} BKP_DIR]
#set ::from_apps [list apiserver]

#get_apps_exceptions 4
#set ret [get_apps_statistics 2]
#set ret [get_unix_statistics 10]
#set ret [get_apps_logs 3]
set ret [get_apps]
puts $ret
