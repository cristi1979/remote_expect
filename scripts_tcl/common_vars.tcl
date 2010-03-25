foreach script [glob [file join $path_tcl_scripts/expect/ *.tcl]] {
  source $script
}

foreach script [glob [file join $path_tcl_scripts/common/ *.tcl]] {
  source $script
}

foreach script [glob [file join $path_tcl_scripts/app_logs_paths/ *.tcl]] {
  source $script
}

foreach script [glob [file join $path_tcl_scripts/oracle_scripts/ *.tcl]] {
  source $script
}

set sshid 0
set sshpid -1
set timeout 60
set long_timeout 180
set oracle_timeout 300
set orig_prompt ""
set new_prompt "\r\n$ "
set file_data ""
set extra_exp ""
set extra_send ""
set operatingsystem ""
set ossolaris "solaris"
set oslinux "linux"
#so we don't backup everything:
set files_to_bkp { "somethingthatdoesnotexist" }
set maximum_size_to_backup 2000000000
set files_to_get [list]
set from_apps [list]
set saved_output [list]
set skip_list [list]
set bkp_rem_dir [directpathname "/tmp/mindcti"]
set remote_skip_file "$bkp_rem_dir/files_to_skip"
set local_tmp_dir "/var/tmp/"
set status_path [directpathname "/var/run/mind"]
set local_dir_base [directpathname "/media/share/backups/remote_files"]
set local_dir [directpathname "$local_dir_base/$customer_name"]
set oracle_sql_dir [directpathname "$path_tcl_scripts/../oracle_sql"]
#this is the default filename of the tar gzip result
set bkp_rem_archive "archive"
set get_period 60
set str_unix_statistics "unix_statistics"
myhash -add ::applications_array [list $::str_unix_statistics $bkp_rem_dir "" "*mind_*.log"] [list statistics]
set str_app_exceptions "apps_exceptions"
set str_app_logs "apps_logs"
set str_app_statistics "apps_statistics"
set str_app_skipdirs "apps_dir"
## applications_array has the following format: applications_array->type->app_dir->relative_path_to_log_dir->files = app_name
array set applications_array {}
array set tmp_array {}
