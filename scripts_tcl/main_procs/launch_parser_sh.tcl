proc launch_parser_sh {parser_type {stats_type ""}} {
  if {$parser_type != "statistics" && $parser_type != "exceptions"} {
    puts "\n\tERR: Unknown type for parser: $parser_type. We expect statistics or exceptions."
    return $::ERR_IMPOSSIBLE
  }

  if {![file exists $::local_dir/$::bkp_rem_archive.tgz]} {
    puts "\n\tERR: File to extract: $::local_dir/$::bkp_rem_archive.tgz does not exist."
    return $::ERR_IMPOSSIBLE
  }
#set local dirs and extract files
  set local_dir_tmp_base "$::local_dir_outputfiles/$::customer_name/$::ip/$parser_type/"
  set local_dir_tmp "$local_dir_tmp_base/tmp_[randomstring 4]"
  file mkdir $local_dir_tmp
  set local_dir_tmp_base [directpathname "$local_dir_tmp_base"]
  set local_dir_tmp [directpathname "$local_dir_tmp"]

  puts "\n\tMSG: Extracting files locally."
  spawn -noecho tar -xpvzf $::local_dir/$::bkp_rem_archive.tgz -C $local_dir_tmp
  expect {
    eof {  puts "\n\tMSG: Done"; set ret $::OK }
    timeout { puts "\n\tERR: Could not extract files."; set ret $::ERR_CANTEXTRACT }
    "tar: Error is not recoverable: exiting now" { puts "\n\tERR: Extract error."; set ret $::ERR_TAR_GENERIC; }
  }

  if {!$ret} {
    catch wait reason
    set ret [expr [lindex $reason 3] + $::ERR_TAR_ERROR]
  }

  if {![expr $ret - $::ERR_TAR_ERROR]} {
    #for unix statistics we don't need much to do
    if {$parser_type=="statistics" && $stats_type == "unix"} {
      eval spawn -noecho "bash $::scripts_bash_dir/parse_statistics.sh $stats_type $local_dir_tmp $::customer_name $::ip"
      expect {
	eof {  puts "\n\tMSG: Done."; set ret $::OK }
	timeout { puts "\n\tERR: Could not execute app."; set ret $::ERR_CANT_EXECUTE_APP }
      }
      if {!$ret} { catch wait reason; set ret [expr [lindex $reason 3] + $::ERR_APP_ERROR ]}
    } else {
      #  get from the applications array only the part we need: exceptions/statistics from the monitored apps
      array unset type_array
      if {$parser_type == "exceptions"} {
	myhash -getnode ::applications_array $::str_app_exceptions $::from_apps
      } elseif {$parser_type == "statistics"} {
	myhash -getnode ::applications_array $::str_app_statistics $::from_apps
      }
      myhash -clean ::tmp_array
      # this will feel type_array with what we want
#=== for is from here
      foreach item [get_files_rec $local_dir_tmp f] {
	if {[file size $item] > 1} {
	  # we get the remote file full path: extract the local_dir from file name
	  regsub "$local_dir_tmp" $item "" rem_file_path
	  foreach key [array names ::tmp_array] {
	    # from the array, for each element, remove quotes, split it by comma and join by / all, but first
	    set tmp_list [split [string trim $key \"] ","]
	    set file_name_regexp [join [lrange $tmp_list 1 [llength $tmp_list]] \/]
	    if {[string match $file_name_regexp* $rem_file_path]} {
	      if { ![info exists type_array($::tmp_array($key))] } {
		set type_array($::tmp_array($key)) $item
	      } else {
		set tmp_list $type_array($::tmp_array($key))
		lappend tmp_list $item
		set type_array($::tmp_array($key)) $tmp_list
	      }
	      break
	    }
	  }
	}
      }
#=== until here

#+++ for is from here
      #launch the script for each app and break in case of error
      set attachements ""
      foreach key [array names type_array] {
	if {$parser_type == "exceptions"} {
	  eval spawn -noecho "bash $::scripts_bash_dir/parse_exceptions.sh $local_dir_tmp_base $key $type_array($key)"
	} elseif {$parser_type == "statistics"} {
	  eval spawn -noecho "bash $::scripts_bash_dir/parse_statistics.sh $stats_type $key $local_dir_tmp_base $type_array($key)"
	}
	expect {
	  eof {  puts "\n\tMSG: Done for $key"; set ret $::OK }
	  timeout { puts "\n\tERR: Could not execute app."; set ret $::ERR_CANT_EXECUTE_APP }
	}
	#check for exit code to be zero. If not, break for loop
	if {!$ret} {
	  catch wait reason
	  set ret [expr [lindex $reason 3] + $::ERR_APP_ERROR ]
	  puts "\n\tERR: Exit code for bash parser was $ret."
	  if {!$ret && $parser_type == "exceptions"} {
	    set attachements [join [glob -nocomplain [file join $local_dir_tmp_base/attachements/*.zip]] " -a "]
	  } 
	}
	if {$ret} { puts "\n\tERR: There was an error."; return $ret }
      }
#+++ until here

#--- if is from here
      #send email for exceptions only
      if {$parser_type == "exceptions" && $attachements != ""} {
	set mymessage "Hello,\r\rNew exceptions where found at customer $::customer_name, machine $::ip.\rThey are attached to this email.\rFull exceptions logs can be found at http://10.0.0.99/backups/remote_files/$::customer_name/$::bkp_rem_archive.tgz.\r\rBest regards,\r\tCoco\r.\r"
	set subject "\"Automatic warning. New exceptions found for $::customer_name, machine $::ip\""
	set ::timeout $::long_timeout
	puts "\n\tMSG: Sending email with attachements $attachements."
	eval spawn -noecho "/bin/mailx -s $subject -a $attachements [join $::emails " "]"
	exp_send $mymessage
	expect {
	  eof {  puts "\n\tMSG: Done for $key"; set ret $::OK }
	  timeout { puts "\n\tERR: Could not execute app."; set ret $::ERR_CANT_EXECUTE_APP }
	}
	if {!$ret} {
	  catch wait reason
	  set ret [expr [lindex $reason 3] + $::ERR_APP_ERROR ]
	  puts "\n\tERR: Exit code for sending emails was $ret."
	  if {![expr $ret- $::ERR_APP_ERROR]} {eval file delete $attachements}
	}
      }
#--- until here
    }
  } else {
    puts "\n\tERR: Error extracting archive $::local_dir/$::bkp_rem_archive.tgz,"
  }
  file delete -force $local_dir_tmp
  return $ret
}
