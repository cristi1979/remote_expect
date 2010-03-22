foreach script [glob [file join $path_tcl_scripts/common/ *.tcl]] {
  source $script
}

foreach script [glob [file join $path_tcl_scripts/tcl_scripts/ *.tcl]] {
  source $script
}

foreach script [glob [file join $path_tcl_scripts/logs_paths/ *.tcl]] {
  source $script
}

foreach script [glob [file join $path_tcl_scripts/oracle/ *.tcl]] {
  source $script
}

set sshid 0
set sshpid -1
set timeout 60
set long_timeout 180
set orig_prompt ""
set new_prompt "\r\n$ "
set file_data ""
set extra_exp ""
set extra_send ""
#so we don't backup everything:
set files_to_bkp { "somethingthatdoesnotexist" }
set files_to_get [list]
set files_to_skip [list]
set saved_output [list]
set bkp_rem_dir [directpathname "/tmp/mindcti"]
set local_tmp_dir "/var/tmp/"
set status_path [directpathname "/var/run/mind"]
set local_dir_base [directpathname "/media/share/backups/remote_files"]
set local_dir [directpathname "$local_dir_base/$customer_name"]
set oracle_scripts_dir [directpathname "$path_tcl_scripts/../scripts_oracle"]
#this is the default filename of the tar gzip result
set bkp_rem_archive "archive"
set get_period 60
set unix_statistics [list "$bkp_rem_dir/*mind_*.log"]
set apps [list]
set apps_dirs [list]
set apps_exceptions [list]
set apps_logs [list]
set apps_statistics [list]
