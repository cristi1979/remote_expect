proc myhash {cmd hash_array res_array {treelist [list]}} {
  upvar 1 $hash_array hash $res_array result 
  set myname [lindex [info level 0] 0]
#  set listsize [llength treelist]

  switch $cmd {
    "-get" {
      }
    "-add" {
	array set res {}
	if {listsize>1} {
	  myname -add 
	}
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
    "-del" {
      }
    "-zap" {
	array unset hash
      }
    "-print" {
	parray hash
      }
  }

  array set result [array get hash]

  if { [array size exceptions] } {
  foreach app $exceptions() {
    puts $app
    array unset temp 
    set all_files [list]
    foreach index $exceptions($app) { set temp([file mtime $index]) $index}
    foreach index [lsort [array names temp]] {}
    }
  }
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
