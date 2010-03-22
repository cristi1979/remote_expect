#!/bin/expect
source "/media/share/Documentation/cfalcas/q/expect_scripts/customers/mcable/header.tcl"
source "$crt_dir/ips/200.52.193.222.tcl"
set ::get_period 0
#set ret [exec_unix_statistics]
set ret [get_apps_exceptions 2]
puts $ret
