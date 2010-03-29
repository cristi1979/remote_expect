proc ssh_posix_bkp {type file_names {days ""}} {
  set spawn_id $::sshid

  set string_count { awk 'BEGIN{size=0}{size=size+$7}END{printf "%20.3f\n",size}' }

  if {$type=="f"} {
    if {$days == ""} { set period "" } else { set period "-mtime -$days" }

    ssh_launch_cmd "find [join $file_names] -type $type $period -ls | $string_count"
    set totalsize [lindex [split $::saved_output] end]
    puts "\n\tMSG: Files total size is $totalsize"
    if [expr $totalsize > $::maximum_size_to_backup] {
      puts "\n\tERR: Total size of files to backup is too big. Getting the last files that sum up to $::maximum_size_to_backup."
      if [ssh_launch_cmd "MAX_SIZE=$::maximum_size_to_backup"] {return 1}
      set string_getmax { awk 'BEGIN{size=0} {if (size<'"$MAX_SIZE"') {size=size+$5;print $NF}}' }

      exp_send "find [join $file_names] -type $type $period -exec ls -lat \{\} \\+ | $string_getmax | xargs tar -cvf - | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
    } elseif [expr $totalsize == 0] {
      puts "\n\tERR: Total size of files to backup is zero."
      return 5
    } else {
      exp_send "find [join $file_names] -type $type $period | xargs tar -cvf - | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
    }
  } else { 
    if {$type=="d"} {
      set tmp_list [list]
      foreach name $::skip_list { lappend tmp_list "-name \"[lindex [split $name \/] end]\"" }
      ssh_launch_cmd "find [join $file_names] \\( [join $tmp_list " -o "] \\) -prune -o -ls | $string_count"
      set totalsize [lindex [split $::saved_output] end]
      puts "\n\tMSG: Dir total size is $totalsize"
      if [expr $totalsize > $::maximum_size_to_backup] {
	puts "\n\tERR: Total size of files to backup is too big. Skip"
	return 1
      } elseif [expr $totalsize == 0] {
	puts "\n\tERR: Total size of files to backup is zero."
	return 5
      } else {
	ssh_writefileremote $::remote_skip_file $::skip_list
	exp_send "tar -cvXf $::remote_skip_file - [join $file_names] | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
      }
    }
  }
  return 0
}
