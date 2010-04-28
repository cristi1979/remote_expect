proc ssh_writefileremote {filename content} {
  set spawn_id $::sshid
  set ret $::ERR_IMPOSSIBLE

  exp_send "cat > \"$::bkp_rem_dir/$filename\" << EOF_COCO_RADA\r[join $content "\n"]\r\rEOF_COCO_RADA\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret $::ERR_EOF }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret $::ERR_TIMEOUT }
    "\r\n$::prompt" {
      puts "\n\tMSG: Finish to write script on remote."
      set ret $::OK
    }
  } 
  return $ret
}
