proc ssh_bkp_files_dirs_list {type file_names {days ""}} {
  set spawn_id $::sshid 
  set crt_timeout $::timeout
  set ::timeout $::long_timeout
  set ret 0

  if {[lsearch -exact [list d f] $type]==-1} {
    puts "\n\tWrong value for type: $type. Should be f (files) or d (dir)."
    return 1
  }

  if {![llength $file_names]} {puts "\n\tNo files to archive.";return 5;}
  
  if {$::operatingsystem==$::ossolaris} {
    if {$days == ""} {
      set period ""
    } else {
      set period "-mtime -$days"
    }

    set string_count { 
awk 'BEGIN{size=0}{size=size+$7}END{printf "%20.3f\n",size}' 
}; set string_count [string trim $string_count "\n"]

    if {$type=="f"} {
      ssh_launch_cmd "find [join $file_names] -type $type $period -ls | $string_count"
      set totalsize [lindex [split $::saved_output] end]
      puts "\n\tTotal size is $totalsize"
      if {$totalsize>$::maximum_size_to_backup} {
	puts "\n\tTotal size of files to backup is too big. Skip"
	return 1
      }

      exp_send "find [join $file_names] -type $type $period | xargs tar -cvf - | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
    } else { 
      if {$type=="d"} {
	set tmp_list [list]
	foreach name $::skip_list { lappend tmp_list "-name \"[lindex [split $name \/] end]\"" }
	ssh_launch_cmd "find [join $file_names] \\( [join $tmp_list " -o "] \\) -prune -o -ls | $string_count"
	set totalsize [lindex [split $::saved_output] end]
	puts "\n\tTotal size is $totalsize"
	if {$totalsize>$::maximum_size_to_backup} {
	  puts "\n\tTotal size of files to backup is too big. Skip"
	  return 1
	}

	writefileremote $::remote_skip_file $::skip_list
	exp_send "tar -cvXf $::remote_skip_file - [join $file_names] | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
      }
    }
  } else {
    if {$::operatingsystem==$::oslinux} {
      puts "\n\tNot implemented."
      return 1
    } else {
      puts "\n\tUndefined OS: $::operatingsystem"
      return 1
    }
  }

  #from here on, we do only checks
  ##check for tar/gzip errors
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout { puts "\n\tTimeout. Return error."; set ret 1;exp_send "\003\r"; exp_continue}
    "gzip: stdout: No space left on device" { 
      puts "\n\tNo more space. Return error."; 
      set ret 15; 
      exp_continue }
    "tar: Cowardly refusing to create an empty archive" {
      puts "\n\tNo files to archive."; 
      set ret 5;
      exp_continue}
    "tar: Missing filenames" {
      puts "\n\ttar error."; 
      set ret 5;
      exp_continue}
    "bash: $::bkp_rem_dir/$::bkp_rem_archive.tgz: No such file or directory*\r\n$::prompt" {
      puts "\n\tThere was a problem with dir $::bkp_rem_dir\n"
      set ret 1;
      exp_continue
    }
    "bash: syntax error" {
      puts "\n\tThere was a problem with the command\n"
      set ret 1;
      exp_continue
    }
    "\r\n$::prompt" { 
      lappend saved_output $expect_out(buffer);
      if {!$ret} {puts "\n\tBackup file created.\n"};
      }
    #-re \[0-9\]|\[a-z\]|\[A-Z\] { lappend saved_output $expect_out(buffer); exp_continue }
    -re "(.*)\n" {exp_continue}
  }
  if {$ret==15} {
    exp_send "rm -f $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
    expect {
      eof { puts "\n\tEOF. Unusual"; set ret 1 }
      timeout { puts "\n\tTimeout. Return error."; set ret 1 }
      "\r\n$::prompt" { puts "\n\tFile $::bkp_rem_dir/$::bkp_rem_archive.tgz deleted." }
    }
  }
  if {$ret} {return $ret}
  ##check if the output file exists and has some size
  exp_send "if \[ -s $::bkp_rem_dir/$::bkp_rem_archive.tgz \]; then echo OK; else echo NOK;fi\r"
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout { puts "\n\tTimeout. Return error."; set ret 1 }
    "*\r\nNOK\r\n$::prompt" {
      puts "\n\tFile $::bkp_rem_dir/$::bkp_rem_archive.tgz does not seem to exist.\n"
      set ret 1
    }
    "*\r\nOK\r\n$::prompt" {
      set ::files_to_get [list]
      lappend ::files_to_get { "somethingthatdoesnotexist" } 
      lappend ::files_to_get "$::bkp_rem_dir/$::bkp_rem_archive.tgz"
      puts "\n\tOK: $::files_to_get\n"
      set ::timeout $crt_timeout
      set ret 0
    }
  }
  return $ret
}
