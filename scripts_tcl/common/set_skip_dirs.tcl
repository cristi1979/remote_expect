proc set_skip {app skip} {
  set ret 1
  foreach key [array names ::applications_array] {
    if {$::applications_array($key)==$app} {
      set app_dir [lindex [split $key ","] 1]
      myhash -add ::applications_array [list $::str_app_skipdirs $app_dir $skip] [list $app]
      set ret 0
      break
    }
  }
  if {$ret} {
    puts "\n\tApp $app does not exist for ip $::ip. Skip list not included."
  }
  return $ret
}
