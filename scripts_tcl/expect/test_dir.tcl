proc test_dir {dir} {
  set res [ssh_launch_cmd "if \[ -e $dir \];then echo OK;else echo NOK;fi"]
  if [ string match "*NOK\r\n$::prompt" $res ] {
    puts "\n\tERR: Not OK. Directory was not created.";
    return 1
  } else {
    puts "\n\tMSG: Dir was created.";
    return 0
  }
}

