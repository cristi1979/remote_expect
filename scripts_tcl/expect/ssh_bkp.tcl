proc ssh_bkp {type file_names {days ""}} {
  set spawn_id $::sshid

  set string_count { awk 'BEGIN{size=0}{size=size+$7}END{printf "%20.3f\n",size}' }

  set string_getmax { awk 'BEGIN{size=0} {if (size+$5<'"$MAX_SIZE"') {size=size+$5;print $NF} else {exit 0}}' }


foreach item $file_names {
    regexp {([[:alnum:]]|-|\.|_|\[|\])+} [file tail $item] file_name
    set dir_name  [file dirname $item]
    set somelist  [lindex [array get somearray $dir_name] end]
    lappend somelist "-name $file_name"
    set somearray($dir_name) $somelist
  }
parray somearray
foreach idx [array names somearray] {
    puts "$idx [join $somearray($idx) \"-o\"]"
 } 
exit
    set ggrep "/usr/sfw/bin/ggrep"
    set ourgrep "$::bkp_rem_dir/gnu_files/grep"
    ssh_launch_cmd "LD_LIBRARY_PATH=$::bkp_rem_dir/gnu_files/;GNU_GREP=`(($ggrep --help &>/dev/null && exit 0; exit 1) && echo $ggrep && exit 0; ($ourgrep --help &>/dev/null && exit 0;exit 1) && echo $ourgrep;)`"
    ssh_launch_cmd "echo \$GNU_GREP"


# for (( i = 0 ; i < ${#q[@]} ; i++ ));do DIR_NAME=${q[$i]}; let i=$i+1; FILE_NAME=${q[$i]};  find $DIR_NAME -name $FILE_NAME\*   -type f | GREP done  | xargs -L 10000 SORT

# gnugrep: 
# $GNU_GREP '\'$DIR_NAME'/\('$FILE_NAME'\)[0-9]\{0,8\}\(_[0-9]\{0,3\}\)\?.log\(.gz\|\.[0-9]\{0,3\}\)\?$';
# posixgrep:
# grep "$DIR_NAME/$FILE_NAME*.*" | grep "\.log";

# solaris 10 sort mtime:
# ls -E | awk '{print $6"-"$7,$5,$NF}' | sort -r
# gnu sort mtime:
# ls --full-time | awk '{print $6"-"$7,$5,$NF}' | sort -r
# perl sort mtime
# perl -e ' foreach(@ARGV) { if (-e $_) { $s=(stat($_))[7]; @d=localtime ((stat($_))[9]); printf "%4d-%02d-%02d-%02d:%02d:%02d.000000000 %d %s\n", $d[5]+1900,$d[4]+1,$d[3],$d[2],$d[1],$d[0],$s,$_ }} '  | sort -r

  set dir_file ""
  foreach item $file_names {
    regexp {([[:alnum:]]|-|\.|_|\[|\])+} [file tail $item] file_name
    set dir_name  [file dirname $item]
    append dir_file "'$dir_name' '$file_name' "
  }
  if {$type=="f"} {
    if {$days == ""} { set period "" } else { set period "-mtime -$days" }

    #ssh_launch_cmd "find [join $file_names] -type $type $period -ls | $string_count"
    set  find_extra "$period  -type $type -ls"
    exp_send "q=( $dir_file );$string_files_begin $string_find $find_extra $string_files_end | $string_count\r"
    expect {
      eof { puts "\n\tERR: EOF. Unusual"; set ret 1 }
      timeout { puts "\n\tERR: Timeout. Return error."; set ret 1;exp_send "\003\r"; exp_continue}
      "\r\n$::prompt" {
	regsub "[string_asis $::prompt]" $expect_out(buffer) "" ::saved_output
	regsub -all {[ \r\t\n]+} $::saved_output " " ::saved_output
	set ::saved_output [string trim $::saved_output " "]
	set totalsize [lindex [split $::saved_output] end] 
      }
    }
    puts "\n\tMSG: Files total size is $totalsize"
    if {$totalsize==""} {
      puts "\n\tERR: Can't get files total size."
      return 1
    }
    if [expr {$totalsize > $::maximum_size_to_backup}] {
      puts "\n\tERR: Total size of files to backup is too big. Getting the last files that sum up to $::maximum_size_to_backup."
      ssh_launch_cmd "MAX_SIZE=$::maximum_size_to_backup"
      
      set find_extra "$period  -type $type -exec ls -lt \{\} \\;";
      exp_send "q=( $dir_file ); $string_files_begin $string_find $find_extra $string_files_end | $string_getmax | xargs tar -cvf - | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
    } elseif [expr {$totalsize == 0}] {
      puts "\n\tERR: Total size of files to backup is zero."
      return 5
    } else {
      set find_extra  "$period  -type $type"; 
      exp_send "q=( $dir_file ); $string_files_begin $string_find $find_extra $string_files_end | xargs tar -cvf - | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
    }
  } else { 
    if {$type=="d"} {
      set tmp_list [list]
      foreach name $::skip_list { lappend tmp_list "-name \"[lindex [split $name \/] end]\"" }
      ssh_launch_cmd "find [join $file_names] \\( [join $tmp_list " -o "] \\) -prune -o -ls | $string_count"
      set totalsize [lindex [split $::saved_output] end]
      puts "\n\tMSG: Dir total size is $totalsize"
      if [expr {$totalsize > $::maximum_size_to_backup}] {
	puts "\n\tERR: Total size of files to backup is too big. Skip"
	return 1
      } elseif [expr {$totalsize == 0}] {
	puts "\n\tERR: Total size of files in dir to backup is zero."
	return 5
      } else {
	ssh_writefileremote $::remote_skip_file $::skip_list
	exp_send "tar -cvXf $::remote_skip_file - [join $file_names] | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
      }
    }
  }
  return 0
}
