set database_ip "10.0.0.1"
set customer_name "local"

if { $argc != 0 } {
  set local_dir [lindex $argv 0];
}

set crt_dir [file normalize [file dirname [info script]]]
set path_tcl_scripts "$crt_dir/../../scripts_tcl/"
source "$path_tcl_scripts/common_vars.tcl"
set path_tcl_scripts [directpathname "$crt_dir/../../scripts_tcl/"]
set database_user [string_asis "iristel"]
set database_pass [string_asis "iristel"]
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
