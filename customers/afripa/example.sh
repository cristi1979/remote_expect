#!/bin/expect 
source "/media/share/Documentation/cfalcas/q/expect_scripts/customers/afripa/header.tcl"
source "$crt_dir/ips/41.223.208.35.tcl"
set ::get_period 0
#set ::files_to_skip [list "./nohup.out.old" "./JBOSS_old/" "./Cdrs2Export/" "./CDRs2Export/" "./log"]
#set ret [get_unix_statistics 15]
set ret [get_apps_exceptions 1]
#set ret [get_apps_logs 1]
#set ret [get_apps_statistics 10]
puts $ret

