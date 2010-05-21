set database_ip "10.16.20.11"
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
lappend ::emails "cristian.serban@mindcti.com"
lappend ::emails "ovidiu.hretcanu@mindcti.com"

file mkdir $local_dir
file mkdir $timestamp_path
