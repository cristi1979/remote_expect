proc ssh_bkp {type file_names {days ""}} {
  set spawn_id $::sshid
  set ::timeout $::long_timeout 
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
# perl -e ' foreach(@ARGV) { if (-e $_) { $s=(stat($_))[7]; @d=localtime ((stat($_))[9]); printf "%4d-%02d-%02d-%02d:%02d:%02d.000000000 %d %s\n", $d[5]+1900,$d[4]+1,$d[3],$d[2],$d[1],$d[0],$s,$_ }} ' | sort -r
# last sort
# sort -r
  set string_count { awk 'BEGIN{size=0}{size=size+$7}END{printf "%20.3f\n",size}' }

  if {$type=="l"} {
    ssh_launch_cmd "ls -la \"[join [lsort -unique $file_names] \"\ \"]\" | $string_count"
    set totalsize [lindex [split $::saved_output] end]
    puts "\n\tMSG: Dir total size is $totalsize"

    if [expr {$totalsize > $::maximum_size_to_backup}] {
      puts "\n\tERR: Total size of files to backup is too big. Skip"
      return 1
    } elseif [expr {$totalsize == 0}] {
      puts "\n\tERR: Total size of files in dir to backup is zero."
      return 5
    } else {
      exp_send "tar -cvf - \"[join [lsort -unique $file_names] \"\ \"]\" | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
    }
  } elseif {$type=="f"} {
    if {$days == ""} { set period "" } else { set period "-mtime -$days" }
    set string_getmax "awk 'BEGIN{size=0} {if (size+\$2<$::maximum_size_to_backup) {size=size+\$2;print \$NF} else {exit 0}}'"
    set regexpgrep {[0-9]\{0,8\}\(_[0-9]\{0,3\}\)\?.log\(.gz\|\.[0-9]\{0,3\}\)\?$}
    set ggrep "/usr/sfw/bin/ggrep"
    set egrep "/usr/xpg4/bin/egrep"
    set ourgrep "$::bkp_rem_dir/gnu_files/grep"
    set ourls "$::bkp_rem_dir/gnu_files/ls"
    set perl_sort {perl -e ' foreach(@ARGV) { if (-e $_) { $s=(stat($_))[7]; @d=localtime ((stat($_))[9]); printf "%4d-%02d-%02d-%02d:%02d:%02d.000000000 %d %s\n", $d[5]+1900,$d[4]+1,$d[3],$d[2],$d[1],$d[0],$s,$_ }} ' | sort -r}
    set awk_cmd {awk '{print $6"-"$7,$5,$NF}'}
    set find_all [list]

    foreach item $file_names {
	regexp {([[:alnum:]]|-|\.|_|\[|\])+} [file tail $item] file_name
	set dir_name  [file dirname $item]
	set somelist  [lindex [array get somearray $dir_name] end]
	lappend somelist "'$file_name'"
	set somearray($dir_name) $somelist
      }
    foreach dir [array names somearray] {
	set find_cmd "find $dir \\( -name [join [lsort -unique $somearray($dir)] \\*\.log\*\ -o\ -name\ ]\\*\.log\* \\) -type $type $period"
	set ggrep_cmd " '$dir/\\([join [lsort -unique $somearray($dir)] \\|]\\)$regexpgrep'"
	set egrep_cmd  " -e '$dir/'\\([join [lsort -unique $somearray($dir)] \\|]\\)$regexpgrep"
	lappend find_all "$find_cmd | \r
    ( LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$::bkp_rem_dir/gnu_files/;\r
    (grep --help &>/dev/null && exit 0; exit 1) 						&& echo gnu grep 1>&2 	&& (grep $ggrep_cmd; exit 0)	 	&& exit 0;\r
    ($ggrep --help &>/dev/null && exit 0; exit 1)						&& echo $ggrep 1>&2 	&& ($ggrep $ggrep_cmd; exit 0)	 	&& exit 0;\r
    ($egrep -q -e \\\[0-9\\\]\\{1,2\\} $egrep &>/dev/null && exit 0; exit 1) 	&& echo $egrep 1>&2	&& ($egrep $egrep_cmd; exit 0)	 	&& exit 0;\r
    ($ourgrep --help &>/dev/null && exit 0;exit 1) 					&& echo $ourgrep 1>&2 	&& ($ourgrep $ggrep_cmd; exit 0)	&& exit 0;\r
    echo lame grep && grep \".log\";
    )"
    } 

    set sort_cmd "([join $find_all ";"])  | \r
    ( LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$::bkp_rem_dir/gnu_files/;\r
    (ls --full-time /dev/null &>/dev/null && exit 0; exit 1)	&& echo gnu ls sort 1>&2 	 && (xargs -L 10000 ls --full-time | $awk_cmd | sort -r; exit 0)		&& exit 0;\r
    (ls -E /dev/null &>/dev/null && exit 0; exit 1) 		&& echo sol10 ls sort 1>&2 && (xargs -L 10000 ls -E | $awk_cmd | sort -r; exit 0)			&& exit 0;\r
    (perl -e \"\" &>/dev/null && exit 0; exit 1) 			&& echo perl sort 1>&2	 && (xargs -L 10000 $perl_sort  | sort -r; exit 0)				&& exit 0;\r
    ($ourls --full-time /dev/null &>/dev/null && exit 0;exit 1) 	&& echo $ourls 1>&2 	 && (xargs -L 10000 $ourls --full-time | $awk_cmd | sort -r; exit 0) && exit 0;\r
    echo lame sort && ls -la | $awk_cmd | sort -r;
    )"
    regsub -all {[ \r\t\n]+} "$sort_cmd | $string_getmax | xargs tar -cvf - | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz" " " run_cmd
    exp_send "$run_cmd\r"
  } elseif {$type=="d"} {

    set app_skip [list]
    ## add dirs to skip list
    myhash -getnode ::applications_array $::str_app_logs $::from_apps
    myhash -clean ::tmp_array
    foreach key [array names ::tmp_array] {
      set tmp_list [split [string trim $key \"] ","]
      lappend app_skip [join [lrange $tmp_list 1 [llength $tmp_list]-2] \/]
    }

    ## add rest of defined skip lists
    myhash -getnode ::applications_array $::str_app_skipdirs $::from_apps
    myhash -clean ::tmp_array
    foreach key [array names ::tmp_array] {
      set tmp_list [split [string trim $key \"] ","]
      foreach name [lindex $tmp_list 2] {
	lappend app_skip [ join [list [lindex $tmp_list 1] [string_asis [string trim $name \"]]] \/]
      }
    }

    set skip_list [lsort -unique $app_skip]

    set tmp_list [list]
    set find_all [list]
    foreach dir $file_names {
      set app_path ""
      foreach name $skip_list { 
	set app_path ""
	regexp -- "^$dir" "$name" app_path
	if {$app_path!=""} {
	  lappend tmp_list "-name \"[lindex [split $name \/] end]\"" 
	}
      }
      set find_extra ""
      if {[llength $tmp_list]>0} {set find_extra "\\( [join $tmp_list " -o "] \\) -prune -o"}
      lappend find_all "find $dir $find_extra -ls"
    }
    
    ssh_launch_cmd "([join $find_all ";"]) | $string_count"
    set totalsize [lindex [split $::saved_output] end]
    puts "\n\tMSG: Dir total size is $totalsize"

    if [expr {$totalsize > $::maximum_size_to_backup}] {
      puts "\n\tERR: Total size of files to backup is too big. Skip"
      set ::bkp_rem_archive "$::ip\_dir_list_for_app_bkp"
      ssh_launch_cmd "([join $find_all ";"]) | sort -k 7 > $::bkp_rem_dir/$::bkp_rem_archive\r"
      return 0
    } elseif [expr {$totalsize == 0}] {
      puts "\n\tERR: Total size of files in dir to backup is zero."
      return 5
    } else {
      ssh_launch_cmd "ls -d \"[join $skip_list \"\ \"]\" > $::bkp_rem_dir/$::remote_skip_file"
      exp_send "tar -cvXf $::remote_skip_file - [join $file_names] | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
    }
  }
  return 0
}
