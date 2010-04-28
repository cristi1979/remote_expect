proc test_dir {dir} {
  set ret $::OK
  if {![ssh_launch_cmd "if \[ -e $dir \];then echo OK;else echo NOK;fi"] && $::saved_output!="OK"} {
    puts "\n\tERR: Not OK. Directory was not created.";
    set ret $::ERR_GENERIC
  } else {
    puts "\n\tMSG: Dir was created.";
    set ret $::OK
  }
  return $ret
}

