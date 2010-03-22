proc ssh_launch_cmd {cmd {output_file "&1"} {error_file "&2"}} {
  set spawn_id $::sshid
  set crt_timeout $::timeout
  set ::timeout $::long_timeout
  exp_send "$cmd 1>$output_file 2>$error_file\r"
  expect {
    eof { puts "\n\tEOF. Unusual"; set ret 1 }
    timeout { puts "\n\tTimeout. Return error."; set ret 1 }
    "$::prompt" {
      puts "\n\tCommand ended."
      set ::timeout $crt_timeout
      if {$output_file!="&1"} { lappend ::files_to_get "$output_file" }
      if {$error_file!="&2"} { lappend ::files_to_get "$error_file" }
      lappend saved_output $expect_out(buffer)
      set ret 0
    }
  }
  return $ret;
}
