set database_ip "172.20.5.129"
set database_user {mind}
set database_pass {mind}

if { $argc != 0 } {
  set local_dir [lindex $argv 0];
}

set crt_dir [file normalize [file dirname [info script]]]
set scripts_tcl_dir "$crt_dir/../../scripts_tcl/"
source "$scripts_tcl_dir/global_vars.tcl"
set scripts_tcl_dir [directpathname "$crt_dir/../../scripts_tcl/"]
set timestamp_path "$::status_path/$customer_name"
lappend ::emails "ciprian.teiosanu@mindcti.com"

file mkdir $local_dir
file mkdir $timestamp_path
##Example names =====
#set dynamic_name_example [clock seconds]
#set fix_name_example "archive"
#set dir_prefix_example "/tmp/mindcti"
#set dynamic_dir_example $dir_prefix_example/$dynamic_name_example
#set fix_dir_example $dir_prefix_example/fix_dir
#====================
