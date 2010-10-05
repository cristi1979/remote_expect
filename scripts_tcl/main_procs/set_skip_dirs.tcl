proc set_skip {app skip} {
  set ret $::ERR_GENERIC

  foreach key [array names ::applications_array] {
    set app_type [lindex [split $key ","] 0]
    if {[lindex $::applications_array($key) 0]==$app && $app_type==$::str_app_skipdirs} {
      set app_dir [lindex [split $key ","] 1]
      myhash -add ::applications_array [list $::str_app_skipdirs $app_dir $skip] [list $app]
      set ret $::OK
      break
    }
  }
  if {$ret} {
    puts "\n\tERR: App $app does not exist for ip $::ip. Skip list not included."
  }
  return $ret
}
