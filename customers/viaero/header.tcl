set database_ip "10.1.136.91"
set customer_name "viaero"

if { $argc != 0 } {
  set local_dir [lindex $argv 0];
}

set crt_dir [file normalize [file dirname [info script]]]
#set path_tcl_scripts [file normalize "/media/share/Documentation/cfalcas/q/scripts_expect/"]
set path_tcl_scripts [file normalize "$crt_dir/../../scripts_expect/"]
source "$path_tcl_scripts/common_vars.tcl"
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
