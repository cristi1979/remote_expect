proc parse_exceptions {} {
  if {![file exists $::local_dir/$::bkp_rem_archive.tgz]} {
    puts "\n\tERR: File to extract: $::local_dir/$::bkp_rem_archive.tgz does not exist."
    return 1
  }

  set local_dir_tmp_base "$::local_dir_outputfiles/$::customer_name/$::ip/exceptions/"
  set local_dir_tmp "$local_dir_tmp_base/tmp_[randomstring 4]"
  file mkdir $local_dir_tmp
  set local_dir_tmp_base [directpathname "$local_dir_tmp_base"]
  set local_dir_tmp [directpathname "$local_dir_tmp"]

  puts "\n\tMSG: Extracting files locally."
  spawn -noecho tar -xvzf $::local_dir/$::bkp_rem_archive.tgz -C $local_dir_tmp
  expect {
    eof {  puts "\n\tMSG: Done"; set ret 0 }
    timeout { puts "\n\tERR: Could not extract files."; set ret 2 }
    "tar: Error is not recoverable: exiting now" { puts "\n\tERR: Extract error."; set ret 2; }
  }

  if {!$ret} {
    catch wait reason
    set ret [lindex $reason 3]
  }
  if {!$ret} {
    #  get from the applications array only the part we need: exceptions from the monitored apps
    array unset exceptions_array
    myhash -getnode ::applications_array $::str_app_exceptions $::from_apps
    myhash -clean ::tmp_array
    foreach item [get_files_rec $local_dir_tmp f] {
      if {[file size $item]>1} {
	# we get the remote file full path: extract the local_dir from file name
	regsub "$local_dir_tmp" $item "" rem_file_path
	foreach key [array names ::tmp_array] {
	  # from the array, for each element, remove quotes, split it by comma and join by / all, but first
	  set tmp_list [split [string trim $key \"] ","]
	  set file_name_regexp [join [lrange $tmp_list 1 [llength $tmp_list]] \/]
	  if {[string match $file_name_regexp $rem_file_path]} {
	    if { ![info exists exceptions_array($::tmp_array($key))] } {
	      set exceptions_array($::tmp_array($key)) $item
	    } else {
	      set tmp_list $exceptions_array($::tmp_array($key))
	      lappend tmp_list $item
	      set exceptions_array($::tmp_array($key)) $tmp_list
	    }
	    break
	  }
	}
      }
    }
    foreach key [array names exceptions_array] {
      eval spawn -noecho "bash $::scripts_bash_dir/parse_exceptions.sh $local_dir_tmp_base $::customer_name $::ip $key [join $::emails ","]  $exceptions_array($key)"
      expect {
	eof {  puts "\n\tMSG: Done for $key"; set ret 0 }
	timeout { puts "\n\tERR: Could not execute app."; set ret 2 }
      }

      if {!$ret} {
	catch wait reason
	set ret [lindex $reason 3]
      }
    }
  } else {
    puts "\n\tERR: Error extracting archive $::local_dir/$::bkp_rem_archive.tgz,"
  }

  file delete -force $local_dir_tmp
}
