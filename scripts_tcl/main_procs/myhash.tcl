proc myhash {cmd hash_array {path ""} {vals ""}} {
  upvar 1 $hash_array hash
  set myname [lindex [info level 0] 0]
  set ret $::ERR_GENERIC
  if {![array exists hash] && $cmd!="-add"} {
    puts "\n\tERR: Array is not defined."
    return $ret
  }
  
  if {[llength $vals]>2} {
    puts "\n\tERR: Vals should be something like: app \[regexp_to_use\]."
    return $::ERR_GENERIC
  }
  switch $cmd {
    "-clean" {
      # trim the / char and for path add it at the beggining only for element 1
      array set result {}
      foreach key [array names hash] {
	set tmp_list [split $key ","]
	for {set i 1} {$i < [llength $tmp_list]} {incr i} {
	  lset tmp_list $i [string trim [regsub -all "/+" [lindex $tmp_list $i] "/"] "/"]
	}
	set tmp1 "/"; set tmp2 [lindex $tmp_list 1]; set tmp $tmp1$tmp2
	lset tmp_list 1 $tmp
	set result([join $tmp_list ","]) $hash($key)
      }
      array unset ::tmp_array
      array set ::tmp_array [array get result]
    }
    "-getnode" {
	if {[llength $vals]>1} {
	  puts "\n\tERR: Vals for getnode should be something like: app. We have: $vals."
	  return $::ERR_GENERIC
	}
	array unset ::tmp_array
	if {![llength $path]} {
	  puts "\n\tERR: We need the path."
	} else {
	  if {[llength $vals]} {
	    if {[llength [array names hash $path]]==1} {
	      foreach key [array names hash $path] {
		if {[lsearch -exact $vals [lindex $hash($key) 0]] != -1 } {
		  set ::tmp_array("$key") $hash($key)
		}
	      }
	      if {![array exists ::tmp_array]} {
		array set ::tmp_array {}
	      }
	    } else {
	      foreach key [array names hash $path,*] {
		if {[lsearch -exact $vals [lindex $hash($key) 0]] != -1 } {
		  set ::tmp_array("$key") $hash($key)
		}
	      }
	      if {![array exists ::tmp_array]} {
		array set ::tmp_array {}
	      }
	    }
	  } else {
	    if {[llength [array get hash $path]]==2} {
	      array set ::tmp_array [array get hash $path]
	    } else {
	      array set ::tmp_array [array get hash $path,*]
	    }
	  }
	  set ret $::OK
	}
      }
    "-add" {
	if {![llength $path] || ![llength $vals] } {
	  puts "\n\tERR: We need the path and the values."
	} else {
	  set hash([join $path ","]) $vals
	  set ret $::OK
	}
      }
    "-delnode" {
	if {[llength $vals]>1} {
	  puts "\n\tERR: Vals for delnode should be something like: app."
	  return $::ERR_GENERIC
	}

	if {![llength $path]} {
	  puts "\n\tERR: We need the path."
	} else {
	  myhash -getnode ::applications_array $path
	  if {[llength $vals]} {
	    if {[array size ::tmp_array]==1} {
	      set name [array names ::tmp_array $path]
	      if {[lindex $::tmp_array($name) 0]==$vals} {
			array unset hash $path
	      }
	    } else {
		  foreach key [array names ::tmp_array] {
			if {[lsearch -exact $vals [lindex $hash($key) 0]] != -1 } {
			  array unset hash $key
			}
		  }
		}
	  } else {
	    if {[array size ::tmp_array]==1} {
		  array unset hash $path
		} else {
		  array unset hash $path,*
		}
	    }
	  set ret $::OK
	}
      }
    "-zap" {
	array unset hash
	set ret $::OK
      }
    "-print" {
	parray hash
	set ret $::OK
      }
  }
  return $ret
}

#hash example:
#   ("apps_logs,/u01/mind/mindcti/engine,syslog,jgroups") = sipengine
# appname
#    => log
#	=> logstring1
#	=> logstring2
#	=> logstring3
#    => exceptions
#	=> logex1
#	=> logex2
#    => dir
#	=> path
#    => stats
#	=> stats1
#	=> stats2
#    => exclude
#	=> dir1
#	=> dir2
#	=> file1
#	=> file2
#	=> dir3
# 
