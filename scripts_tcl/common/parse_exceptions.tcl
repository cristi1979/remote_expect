proc parse_exceptions {} {
  if {![file exists $::local_dir/$::bkp_rem_archive.tgz]} {
    puts "\n\tFile to extract: $::local_dir/$::bkp_rem_archive.tgz does not exist."
    return 1
  }
  set local_dir_tmp $::local_dir/tmp
  file delete -force $local_dir_tmp
  file mkdir $local_dir_tmp
  puts "\n\tExtracting files locally."
  spawn -noecho tar -xvzf $::local_dir/$::bkp_rem_archive.tgz -C $local_dir_tmp
  expect {
    eof {  puts "\n\tDone"; set ret 0 }
    timeout { puts "\n\tCould not extract files."; set ret 2 }
    "tar: Error is not recoverable: exiting now" { puts "\n\tExtract error."; set ret 2; }
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
# 	    puts "daaaaa: file $item from $rem_file_path is like $file_name_regexp of type $::tmp_array($key)"
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
      puts "+++run app for $key with files $exceptions_array($key)"
      eval spawn ls $key $exceptions_array($key)
      expect {
	eof {  puts "\n\tDone for $key"; set ret 0 }
	timeout { puts "\n\tCould not execute app."; set ret 2 }
      }

      if {!$ret} {
	catch wait reason
	set ret [lindex $reason 3]
      }
    }
  } else {
    puts "\n\tError extracting archive $::local_dir/$::bkp_rem_archive.tgz,"
  }

  file delete -force $local_dir_tmp
}
