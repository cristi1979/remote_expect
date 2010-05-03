proc ssh_launch_cmd {cmd {output_file "&1"} {error_file "&2"}} {
  set spawn_id $::sshid
  set crt_timeout $::timeout
  set ::timeout $::long_timeout
  set ret $::OK
  set ::saved_output [list]
  if {[test_console]} {return $::ERR_IMPOSSIBLE}
  set mycmd "$cmd 1>$output_file 2>$error_file\r"
  exp_send "$mycmd"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret $::ERR_TIMEOUT; exp_send "\003\r"; exp_continue }
    "\r\n$::prompt" {
      #puts "\n\tMSG: Command ended."
      set ::timeout $crt_timeout
      if {$output_file!="&1" && $output_file!="/dev/null"} { lappend ::files_to_get "$output_file" }
      if {$error_file!="&2" && $error_file!="/dev/null"} { lappend ::files_to_get "$error_file" }
      regsub "[string_asis $mycmd]" $expect_out(buffer) "" ::saved_output 
      regsub "[string_asis $::prompt]" $::saved_output "" ::saved_output
      regsub -all {[ \r\t\n]+} $::saved_output " " ::saved_output
      set ::saved_output [string trim $::saved_output " "]
      #lappend ::saved_output $expect_out(buffer)
    }
  }
  return $ret;
}
