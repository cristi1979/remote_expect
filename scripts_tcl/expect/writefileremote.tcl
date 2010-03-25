proc writefileremote {filename content} {
  set spawn_id $::sshid
  set ret 0
  exp_send "cat > \"$filename\" << EOF_COCO_RADA\r[join $content "\n"]\r\rEOF_COCO_RADA\r"
  expect {
    eof { puts "\n\tEOF. Unusual"; return 1 }
    timeout { puts "\n\tTimeout. Return error."; return 1 }
    "$::prompt" {
      puts "\n\tFinish to write script on remote."
    }
  } 
  return $ret
}
