proc parse_unix_statistics {} {
if {![file exists $::local_dir/$::bkp_rem_archive.tgz]} {
    puts "\n\tERR: File to extract: $::local_dir/$::bkp_rem_archive.tgz does not exist."
    return 1
  }

  set local_dir_tmp_base "$::local_dir_outputfiles/$::customer_name/statistics/"
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
    eval spawn -noecho "bash $::scripts_bash_dir/parse_unix_statistics.sh $local_dir_tmp $::customer_name $::ip"
    expect {
      eof {  puts "\n\tMSG: Done."; set ret 0 }
      timeout { puts "\n\tERR: Could not execute app."; set ret 2 }
    }

    if {!$ret} {
      catch wait reason
      set ret [lindex $reason 3]
    }
  } else {
    puts "\n\tERR: Error extracting archive $::local_dir/$::bkp_rem_archive.tgz,"
  }

  file delete -force $local_dir_tmp 
}