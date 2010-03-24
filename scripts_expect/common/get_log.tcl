proc get_them {logstype {nr_days ""}} {
  myhash -getnode ::applications_array $logstype $::from_apps
  set file_names [list]
  foreach key [array names ::tmp_array] {
    set tmp_list [split [string trim $key \"] ","]
    lappend file_names [join [lrange $tmp_list 1 [llength $tmp_list]] \/]
  }

  set myname [string map {* - [ - ] - : "" / _ \\ _} $::ip\_$logstype]
  return [run_once_command [list bkp_app $file_names $nr_days] $myname]
}

proc get_unix_statistics {{nr_days ""}} {
  set ::from_apps [list]
  return [get_them ::unix_statistics $nr_days]
}

proc get_apps_exceptions {{nr_days ""}} {
  #set ret [get_them $::str_app_exceptions $nr_days]
set ret 0
set ::bkp_rem_archive "200.52.193.222_app_exceptions"
  if {$ret} {
    return $ret
  }
  if {![file exists $::local_dir/$::bkp_rem_archive.tgz]} {
    puts "\n\tFile to extract: $::local_dir/$::bkp_rem_archive.tgz does not exist."
    return 1
  }
  set local_dir_tmp $::local_dir/tmp
  file delete -force $local_dir_tmp
  file mkdir $local_dir_tmp
  puts "\n\tExtracting files locally."
  spawn -noecho tar -xvzf $::local_dir/$::bkp_rem_archive.tgz -C $local_dir_tmp
  expect {
    eof {  puts "\n\tDone"; set ret 0 }
    timeout { puts "\n\tCould not extract files."; set ret 2 }
    "tar: Error is not recoverable: exiting now" { puts "\n\tExtract error."; set ret 2; }
  }

  if {!$ret} {
    catch wait reason
    set ret [lindex $reason 3]
  }
  if {!$ret} {
    foreach item [get_files_rec $local_dir_tmp f] {
      #we will try to find now the aplication like this: remove $local_dir_tmp string from the extracted file
      #this will give us the path from the remote host 
      #for each application, reset the applications and set the exception dir to an empty string
      #this will give as the last part only from the log dir
      #for each log regexp, match it with the remote file path
      #even so, we can still have more then one application match :(
      if {[file size $item]>1} {
    regsub "$local_dir_tmp" $item "" rem_file_path

  myhash -getnode ::applications_array $::str_app_exceptions $::from_apps
  set file_names [list]
  foreach key [array names ::tmp_array] {
    set tmp_list [split [string trim $key \"] ","]
    set file_name [join [lrange $tmp_list 1 [llength $tmp_list]] \/]
    regsub "$file_name" $rem_file_path "" rem_file_path1
puts "   sdfa $rem_file_path1"
    if {[string match $file_name $rem_file_path]} {
      puts "dadada $key $file_name $rem_file_path"
    } else {
      puts "nununu $key $file_name $rem_file_path"
    }
  }

	foreach app $bkp_apps {
	  set ::apps_exceptions [list]
	  $app ""
	  foreach log_regexp $::apps_exceptions {
	    if {[string match "*$log_regexp*" $rem_file_path]} {
	      if { ![info exists exceptions($app)] } { 
		set exceptions($app) "$item" 
		lappend exceptions() $app
	      } else { 
		set tmplist [list]
		set tmplist $exceptions($app)
		lappend tmplist $item
		set exceptions($app) "$tmplist" 
	      }
	    }
	  }
	}
      }
    }
# local_tmp_dir
# file_data
# write_file
if { [array size exceptions] } {
foreach app $exceptions() {
puts $app
array unset temp 
set all_files [list]
foreach index $exceptions($app) { set temp([file mtime $index]) $index}
foreach index [lsort [array names temp]] {
#read_file $temp($index);lappend all_files $::file_data;lappend all_files "\n"
#spawn cat $temp($index) >> "$::local_tmp_dir/coco$index"
#catch wait reason;puts [lindex $reason 3];puts $reason

}
#puts [join $exceptions($app) "\n"]
#set ::file_data [join $all_files];write_file "$::local_tmp_dir/coco"
#parray temp
}
}
#comm -2 OLD NEW
#parray exceptions
#spawn mailx -s _Subject_ -a $::local_dir/$::bkp_rem_archive.tgz cristian.falcas@mindcti.com;exp_send "asdf\r.\r";expect ""
    #catch wait reason
    #puts [lindex $reason 3];puts $reason
    set ::apps $bkp_apps;
    set ::apps_exceptions $bkp_apps_exceptions;
    #set ::apps_logs $bkp_apps_logs;
    #set ::apps_statistics $bkp_apps_statistics;
  } else {
    puts "\n\tError extracting archive $::local_dir/$::bkp_rem_archive.tgz,"
  }

  file delete -force $local_dir_tmp

  return $ret
}

proc get_apps_logs {{nr_days ""}} {
  return [get_them $::str_app_logs $nr_days]
}

proc get_apps_statistics {{nr_days ""}} {
  return [get_them $::str_app_statistics $nr_days]
}
