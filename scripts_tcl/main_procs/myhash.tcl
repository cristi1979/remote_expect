proc myhash {cmd hash_array {path ""} {vals ""}} {
  upvar 1 $hash_array hash
  set myname [lindex [info level 0] 0]
  set ret 1
  if {![array exists hash] && $cmd!="-add"} {
    puts "\n\tERR: Array is not defined."
    return $ret
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
#       puts "\n\treturning for clean"
#       puts "\n\t=================="
#       parray ::tmp_array
#       puts "\n\t=================="
    }
    "-getnode" {
	array unset ::tmp_array
	if {![llength $path]} {
	  puts "\n\tERR: We need the path."
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

# 	puts "\n\treturning for $path only $vals"
# 	puts "\n\t=================="
# 	parray ::tmp_array
# 	puts "\n\t=================="
      }
    "-add" {
	if {![llength $path] || ![llength $vals] } {
	  puts "\n\tERR: We need the path and the values."
	} else {
	  set hash([join $path ","]) $vals
	  set ret 0
	}
      }
    "-delnode" {
	if {![llength $path]} {
	  puts "\n\tERR: We need the path."
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
