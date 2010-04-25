proc ssh_writefileremote {filename content} {
  set spawn_id $::sshid
  set ret 0

  exp_send "cat > \"$::bkp_rem_dir/$filename\" << EOF_COCO_RADA\r[join $content "\n"]\r\rEOF_COCO_RADA\r"
  expect {
    eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
    timeout { puts "\n\tERR: Timeout. Return error."; set ret 1 }
    "\r\n$::prompt" {
      puts "\n\tMSG: Finish to write script on remote."
      set ret 0
    }
  } 
  return $ret
}
