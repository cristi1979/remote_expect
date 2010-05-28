proc add_app {app_name app_dir {logs_dir "log"}} {
    set exceptions_list [$app_name "exceptions"]
    set logs_list [$app_name "logs"]
    set stats_list [$app_name "statistics"]
    set skip_list [$app_name "skip"]
    if {$logs_dir=="log"} { set logs_dir "$app_dir/log"}
    set reg [logs_regular_expresions $app_name]

  foreach word $exceptions_list {
    if {$word!="XXX_XXX"} {	myhash -add ::applications_array [list $::str_app_exceptions $logs_dir "$word"] [list $app_name $reg] } else {
	    myhash -add ::applications_array [list $::str_app_exceptions $app_dir ""] [list $app_name] }
  }

  foreach word $logs_list {
	if {$word!="XXX_XXX"} {	myhash -add ::applications_array [list $::str_app_logs $logs_dir "$word"] [list $app_name $reg] } else {
	    myhash -add ::applications_array [list $::str_app_logs $app_dir ""] [list $app_name] }
  }

  foreach word $stats_list {
	if {$word!="XXX_XXX"} {	myhash -add ::applications_array [list $::str_app_statistics $logs_dir "$word"] [list $app_name $reg] } else {
	    myhash -add ::applications_array [list $::str_app_statistics $app_dir ""] [list $app_name] }
  }

  foreach word $skip_list {
	if {$word!="XXX_XXX"} {	    myhash -add ::applications_array [list $::str_app_skipdirs $app_dir "$word"] [list $app_name $reg] } else {	
	    myhash -add ::applications_array [list $::str_app_skipdirs $app_dir ""] [list $app_name]	}
  }
  
  $app_name "extra" $app_dir $logs_dir
}
