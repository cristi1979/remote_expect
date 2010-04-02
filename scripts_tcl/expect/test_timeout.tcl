proc test_timeout {val} {
  if {$val} {
    ##Timeout test
    ssh_launch_cmd "for ((i=1;i<=$::long_timeout+1;i++));do sleep 1;echo \$i;done;echo done > /dev/null 2>&1"
  } else {
    ##No timeout test
    ssh_launch_cmd "for ((i=1;i<=$::long_timeout+1;i++));do sleep 1;echo \$i;done;echo sleep;sleep [expr {$::long_timeout + 2}];"
  }
}
