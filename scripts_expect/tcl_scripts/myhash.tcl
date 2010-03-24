proc myhash {cmd hash_array {path ""} {vals ""}} {
  upvar 1 $hash_array hash
  set myname [lindex [info level 0] 0]
  set ret 1
  if {![array exists hash] && $cmd!="-add"} {
    puts "\n\tArray is not defined."
    return $ret
  }
  array unset ::tmp_array

  switch $cmd {
    "-getnode" {
	if {![llength $path]} {
	  puts "\n\tWe need the path."
	} else {
	  if {[llength $vals]} {
	    foreach key [array names hash $path,*] {
	       if {[lsearch -exact $vals $hash($key)] != -1 } {
		set ::tmp_array("$key") $hash($key)
	      }
	    }
	  } else {
	    array set ::tmp_array [array get hash $path,*]
	  }
	  set ret 0
	}

	puts "\n\treturning"
	puts "\n\t=================="
	parray ::tmp_array
	puts "\n\t=================="
      }
    "-add" {
	if {![llength $path] || ![llength $vals] } {
	  puts "\n\tWe need the path and the values."
	} else {
	  set hash([join $path ","]) $vals
	  set ret 0
	}
      }
    "-delnode" {
	if {![llength $path]} {
	  puts "\n\tWe need the path."
	} else {
	  array unset hash $path,*
	  set ret 0
	}
      }
    "-zap" {
	array unset hash
      }
    "-print" {
	parray hash
      }
  }
  return $ret
}

#hash example:
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
#treelist: command, hash, a list of nodes: appname => log => value
