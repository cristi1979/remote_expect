proc ssh_bkp_files_dirs_list {type file_names {days ""}} {
  set spawn_id $::sshid 
  set crt_timeout $::timeout
  set ::timeout $::long_timeout
  set ret 0

  if {[lsearch -exact [list d f] $type]==-1} {
    puts "\n\tERR: Wrong value for type: $type. Should be f (files) or d (dir)."
    return 1
  }

  if {![llength $file_names]} {puts "\n\tERR: No files to archive.";return 5;}
  
  if {$::operatingsystem==$::ossolaris} {
    set ret [ssh_posix_bkp $type $file_names $days]
  } elseif {$::operatingsystem==$::oslinux} {
    set ret [ssh_posix_bkp $type $file_names $days]
  } else {
    puts "\n\tERR: Undefined OS: $::operatingsystem"
    set ret 1
  }
  if [expr {$ret > 0}] {return $ret}

  #from here on, we do only checks
  ##check for tar/gzip errors
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret 1;exp_send "\003\r"; exp_continue}
    "gzip: stdout: No space left on device" { 
      puts "\n\tERR: No more space. Return error."; 
      set ret 15; 
      exp_continue }
    "tar: Cowardly refusing to create an empty archive" {
      puts "\n\tERR: Tar error. No files to archive."; 
      set ret 5;
      exp_continue}
    "tar: Missing filenames" {
      puts "\n\tERR: tar: Missing filenames."; 
      set ret 5;
      exp_continue}
    "bash: $::bkp_rem_dir/$::bkp_rem_archive.tgz: No such file or directory\r\n" {
      puts "\n\tERR: There was a problem with dir $::bkp_rem_dir\n"
      set ret 1;
      exp_continue
    }
    "bash: $::bkp_rem_dir/$::bkp_rem_archive.tgz: Permission denied\r\n" {
      puts "\n\tERR: Can't create file.\n"
      set ret 1;
      exp_continue
    }
    "bash: syntax error" {
      puts "\n\tERR: There was a problem with the command\n"
      set ret 1;
      exp_continue
    }
    #-re "(.*)\n" {exp_continue}
    "\r\n$::prompt" { 
      lappend saved_output $expect_out(buffer);
      set tarerr [ssh_get_lasterror]
      if {$tarerr} {puts "\n\tERR: Tar exited with error code: $tarerr"}
      if {!$ret} {puts "\n\tMSG: Backup file created.\n"};
      }
    #-re \[0-9\]|\[a-z\]|\[A-Z\] { lappend saved_output $expect_out(buffer); exp_continue }
    #-re "(.*)\n" {exp_continue}
  }
  if {$ret==15} {
    exp_send "rm -f $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
    expect {
      eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
      timeout { puts "\n\tERR: Timeout. Return error."; set ret 1 }
      "\r\n$::prompt" { puts "\n\tMSG: File $::bkp_rem_dir/$::bkp_rem_archive.tgz deleted." }
    }
  }
  if {$ret} {return $ret}
  ##check if the output file exists and has some size
  exp_send "if \[ -s $::bkp_rem_dir/$::bkp_rem_archive.tgz \]; then echo OK; else echo NOK;fi\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret 1 }
    "*\r\nNOK\r\n$::prompt" {
      puts "\n\tERR: File $::bkp_rem_dir/$::bkp_rem_archive.tgz does not seem to exist.\n"
      set ret 1
    }
    "*\r\nOK\r\n$::prompt" {
      set ::files_to_get [list]
      lappend ::files_to_get { "somethingthatdoesnotexist" } 
      lappend ::files_to_get "$::bkp_rem_dir/$::bkp_rem_archive.tgz"
      puts "\n\tMSG: OK: $::files_to_get\n"
      set ::timeout $crt_timeout
      set ret 0
    }
  }
  return $ret
}
