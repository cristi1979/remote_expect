proc test_dir {dir} {
  set ret [ssh_launch_cmd "if \[ -e $dir \];then echo OK;else echo NOK;fi"]
  if {!$ret && $::saved_output!="OK"} {
    puts "\n\tERR: Not OK. Directory was not created. Saved output: $::saved_output, return code: $ret.";
    set ret $::ERR_GENERIC
  } else {
    puts "\n\tMSG: Dir was created.";
    set ret $::OK
  }
  return $ret
}
