proc test_dir {dir} {
  set ret 0
  if {![ssh_launch_cmd "if \[ -e $dir \];then echo OK;else echo NOK;fi"] && $::saved_output!="OK"} {
    puts "\n\tERR: Not OK. Directory was not created.";
    set ret 1
  } else {
    puts "\n\tMSG: Dir was created.";
    set ret 0
  }
  return $ret
}

