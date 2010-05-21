set database_ip "82.112.228.31"

if { $argc != 0 } {
  set local_dir [lindex $argv 0];
}

set crt_dir [file normalize [file dirname [info script]]]
set scripts_tcl_dir [file normalize "$crt_dir/../../scripts_tcl/"]
source "$scripts_tcl_dir/global_vars.tcl"
set scripts_tcl_dir [directpathname "$crt_dir/../../scripts_tcl/"]
set timestamp_path "$::status_path/$customer_name"

file mkdir $local_dir
file mkdir $timestamp_path
##Example names =====
#set dynamic_name_example [clock seconds]
#set fix_name_example "archive"
#set dir_prefix_example "/tmp/mindcti"
#set dynamic_dir_example $dir_prefix_example/$dynamic_name_example
#set fix_dir_example $dir_prefix_example/fix_dir
#====================
lappend ::emails "ovidiu.hretcanu@mindcti.com"
