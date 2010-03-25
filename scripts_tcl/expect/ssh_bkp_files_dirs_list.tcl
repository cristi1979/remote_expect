proc ssh_bkp_files_dirs_list {file_names {days ""}} {
  set spawn_id $::sshid 
  set crt_timeout $::timeout
  set ::timeout $::long_timeout
  set ret 0;

  if {![llength $file_names]} {puts "\n\tNo files to archive.";return 5;}
  if {$days == ""} {
    set period ""
  } else {
    set period "-mtime -$days"
  }
  if {$::files_to_skip!=""} {
    #create files_to_skip at $::bkp_rem_dir/files_to_skip
    exp_send "cat > \"$::bkp_rem_dir/files_to_skip\" << EOF_COCO_RADA
      [join $::files_to_skip "\n"]\r[join $::apps_logs "\n"]\rEOF_COCO_RADA\r"
      expect {
	eof { puts "\n\tEOF. Unusual"; return 1 }
	timeout { puts "\n\tTimeout. Return error."; return 1 }
	"$::prompt" {
	  puts "\n\tFinish to write script on remote."
	}
    } 
    exp_send "tar -cvXf $::bkp_rem_dir/files_to_skip - [join $::apps_dirs] | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
  } else {
    #exp_send "find [join $file_names] $period -exec tar -cvf - {} \+ | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
    exp_send "find [join $file_names] $period | xargs tar -cvf - | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
  }
  #from here on, we do only checks
  ##check for tar/gzip errors
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout { puts "\n\tTimeout. Return error."; set ret 1 }
    "gzip: stdout: No space left on device" { 
      puts "\n\tNo more space. Return error."; 
      set ret 5; 
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
    "$::prompt" { 
      lappend saved_output $expect_out(buffer);
      if {!$ret} {puts "\n\tBackup file created.\n"};
      }
    #-re \[0-9\]|\[a-z\]|\[A-Z\] { lappend saved_output $expect_out(buffer); exp_continue }
    #-re "(.*)\n" {exp_continue}
  }
  if {$ret} {return $ret}
  ##check if the output file exists and has some size
  exp_send "if \[ -s $::bkp_rem_dir/$::bkp_rem_archive.tgz \]; then echo OK; else echo NOK;fi\r"
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout { puts "\n\tTimeout. Return error."; set ret 1 }
    "*\r\nNOK\r\n\r\n$::prompt" {
      puts "\n\tFile $::bkp_rem_dir/$::bkp_rem_archive.tgz does not seem to exist.\n"
      set ret 1
    }
    "*\r\nOK\r\n\r\n$::prompt" {
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
