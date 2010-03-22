#!/bin/expect 
source "/media/share/Documentation/cfalcas/q/expect_scripts/customers/viaero/header.tcl"
source "$crt_dir/ips/10.1.136.85.tcl"
set ::get_period 0
set ret [get_unix_statistics 1]
puts $ret
