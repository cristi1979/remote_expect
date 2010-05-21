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
  ssh_launch_cmd "rm -f  $::bkp_rem_dir/$::bkp_rem_archive.tgz"

  if {$type=="l"} {
    ssh_launch_cmd "ls -la \"[join [lsort -unique [lindex $file_names 0]] \"\ \"]\" | $string_count"
    set totalsize [lindex [split $::saved_output] end]
    puts "\n\tMSG: Dir total size is $totalsize"

    if [expr {$totalsize > $::maximum_size_to_backup}] {
      puts "\n\tERR: Total size of files to backup is too big. Skip"
      return $::ERR_GENERIC
    } elseif [expr {$totalsize == 0}] {
      puts "\n\tERR: Total size of files in dir to backup is zero."
      return $::ERR_ZERO_SIZE
    } else {
      exp_send "tar -cvf - \"[join [lsort -unique [lindex $file_names 0]] \"\ \"]\" | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz; echo $?\r"
    }
  } elseif {$type=="f"} {
    if {$days == ""} { set period "" } else { set period "-mtime -$days" }

    set string_getmax "awk 'BEGIN{size=0} {if (size+\$2<$::maximum_size_to_backup) {size=size+\$2;print \$NF} else {exit 100}}'"
    set awk_cmd {awk '{print $6"-"$7,$5,$NF}'}

    set ggrep "/usr/sfw/bin/ggrep"
    set egrep "/usr/xpg4/bin/egrep"
    set ourgrep "$::bkp_rem_dir/gnu_files/grep"
    set ourls "$::bkp_rem_dir/gnu_files/ls"
    set perl_sort {perl -e ' foreach(@ARGV) { if (-e $_) { $s=(stat($_))[7]; @d=localtime ((stat($_))[9]); printf "%4d-%02d-%02d-%02d:%02d:%02d.000000000 %d %s\n", $d[5]+1900,$d[4]+1,$d[3],$d[2],$d[1],$d[0],$s,$_ }} ' | sort -r}

    set find_all [list]

### build an array containing as key the path and regexp and as value a list of common files
    foreach item $file_names {
	regexp {([[:alnum:]]|-|\.|_|\[|\])+} [file tail [lindex $item 0]] file_name
	set dir_name  [file dirname [lindex $item 0]]
	set key [list $dir_name [lindex $item 1]]
	set somelist [list]
	if {[info exists somearray($key)]} {
	  set somelist $somearray($key)
	}
	lappend somelist "'$file_name'"
	set somearray($key) $somelist
      }

ssh_launch_cmd "echo \"\" >  $::bkp_rem_dir/all_files_in_dirs"
    foreach key [array names somearray] {
	set dirfix [lindex $key 0]
	regsub -all "\\\.\\\*" [lindex $key 0] "\*" dirfind
	set regexpfix [lindex $key 1]
	set files $somearray($key)
ssh_launch_cmd "find $dirfind/. \! -name . -prune -type $type | sed s#\\\/.\\\/#\\\/# | xargs $perl_sort >>  $::bkp_rem_dir/all_files_in_dirs"

	### /. \! -name . -prune - don't descend dir. And we fix it back for grep with  | sed s#\\\/.\\\/#\\\/# |
	set find_cmd "find $dirfind/. \! -name . -prune \\( -name [join [lsort -unique $files] \\*\ -o\ -name\ ]\\* \\) -size +1c -type $type $period | sed s#\\\/.\\\/#\\\/#"

	set ggrep_cmd " '$dirfix/\\([join [lsort -unique $files] \\|]\\)$regexpfix' "
	set egrep_cmd  " -e '$dirfix/'\\([join [lsort -unique $files] \\|]\\)$regexpfix"
	set grep_cmd "
    ( LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$::bkp_rem_dir/gnu_files/;
    (grep --ugabugabuga /dev/null &>/dev/null && exit 0; exit 1) 				&& echo grep is insane 1>&2 	&& exit 1;
    (grep --help &>/dev/null && exit 0; exit 1) 						&& echo gnu grep 1>&2 		&& (grep $ggrep_cmd; exit 0)	 	&& exit 0;
    ($ggrep --help &>/dev/null && exit 0; exit 1)					&& echo $ggrep 1>&2 		&& ($ggrep $ggrep_cmd; exit 0)	 	&& exit 0;
    ($egrep -e \\\[0-9\\\]\\{1,2\\} $egrep &>/dev/null && exit 0; exit 1) 	&& echo $egrep 1>&2		&& ($egrep $egrep_cmd; exit 0)	 	&& exit 0;
    ($ourgrep --help &>/dev/null && exit 0;exit 1) 					&& echo $ourgrep 1>&2 		&& ($ourgrep $ggrep_cmd; exit 0)	&& exit 0;
    echo lame grep && grep \".log\";
    )"
	lappend find_all "$find_cmd | $grep_cmd"
    }
ssh_launch_cmd "tar -cvf - $::bkp_rem_dir/all_files_in_dirs | gzip - > $::bkp_rem_dir/$::ip\_all_files_in_dirs.tgz"
lappend ::files_to_get "$::bkp_rem_dir/$::ip\_all_files_in_dirs.tgz"

    set sort_cmd "
    ( LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$::bkp_rem_dir/gnu_files/;
    (ls --ugabugabuga /dev/null &>/dev/null && exit 0; exit 1)		&& echo ls is insane 1>&2 	 && exit 1;
    (ls --full-time /dev/null &>/dev/null && exit 0; exit 1)		&& echo gnu ls sort 1>&2 	 && (xargs -r -L 10000 ls --full-time | $awk_cmd | sort -r; exit 0)	&& exit 0;
    (ls -E /dev/null &>/dev/null && exit 0; exit 1) 			&& echo sol10 ls sort 1>&2 && (xargs -L 10000 ls -E /dodo | $awk_cmd | sort -r; exit 0)		&& exit 0;
    (perl -e \"\" &>/dev/null && exit 0; exit 1) 				&& echo perl sort 1>&2	 && (xargs -L 10000 $perl_sort  | sort -r; exit 0)				&& exit 0;
    ($ourls --full-time /dev/null &>/dev/null && exit 0;exit 1) 	&& echo $ourls 1>&2  && (xargs -r -L 10000 $ourls --full-time | $awk_cmd | sort -r; exit 0)	&& exit 0;
    echo lame sort && ls -la | $awk_cmd | sort -r;
    )"

    set tar_cmd "
    ( LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$::bkp_rem_dir/gnu_files/;
    (tar -cvf - -ugabugabuga /dev/null &>/dev/null && exit 0; exit 1)	&& echo tar is insane 1>&2	&& exit 1;
    (tar -cvf - -T /dev/null &>/dev/null && exit 0; exit 1)	&& echo gnu tar 1>&2	&& (tar -cvf - -T $::bkp_rem_dir/$::bkp_rem_archive; exit 0)		&& exit 0;
    (tar -cvf - -I /dev/null &>/dev/null && exit 0; exit 1) 	&& echo sol tar 1>&2		&& (tar -cvf - -I $::bkp_rem_dir/$::bkp_rem_archive; exit 0)		&& exit 0;
    echo lame no usable tar 1>&2 && exit 1;
    )"

    regsub -all {[ \r\t\n\s]+} "([join $find_all ";"]) | $sort_cmd | ($string_getmax; echo AWK_FORCED_STOP=\$? 1>&2) > $::bkp_rem_dir/$::bkp_rem_archive && $tar_cmd | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz" " " run_cmd
    
    exp_send "$run_cmd\r"
  } elseif {$type=="d"} {

    set tmp_list [list]
    set find_all [list]
    foreach item $file_names {
      set dir_name  [lindex $item 0]
      set app_path ""
      foreach name $::skip_list { 
	set app_path ""
	regexp -- "^$dir_name" "$name" app_path
	if {$app_path!=""} {
	  lappend tmp_list "-name \"[lindex [split $name \/] end]\"" 
	}
      }
      set find_extra ""
      if {[llength $tmp_list]>0} {set find_extra "\\( [join $tmp_list " -o "] \\) -prune -o"}
      lappend find_all "find $dir_name $find_extra -ls"
    }
    
    ssh_launch_cmd "([join $find_all ";"]) | $string_count"
    set totalsize [lindex [split $::saved_output] end]
    puts "\n\tMSG: Dir total size is $totalsize."

    if [expr {$totalsize > $::maximum_size_to_backup}] {
      puts "\n\tERR: Total size of files to backup is too big. Skip."
      set ::bkp_rem_archive "$::ip\_dir_list_for_app_bkp"
      ssh_launch_cmd "([join $find_all ";"]) | sort -k 7 > $::bkp_rem_dir/$::bkp_rem_archive && tar -cvf - $::bkp_rem_dir/$::bkp_rem_archive | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz\r"
      return $::OK
    } elseif [expr {$totalsize == 0}] {
      puts "\n\tERR: Total size of files in dir to backup is zero."
      return $::ERR_ZERO_SIZE
    } else {
      ssh_launch_cmd "ls -d \"[join $::skip_list \"\ \"]\" > $::bkp_rem_dir/$::remote_tar_skip_file"
      if {$::operatingsystem == $::oslinux } {
	exp_send "tar -cvX $::bkp_rem_dir/$::remote_tar_skip_file -f - [join $file_names] | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz; echo $?\r"
      } else {
	exp_send "tar -cvXf $::bkp_rem_dir/$::remote_tar_skip_file - [join $file_names] | gzip - > $::bkp_rem_dir/$::bkp_rem_archive.tgz; echo $?\r"
      }
    }
  }
  return $::OK
}
