proc get_files_rec {{dir .} {types {b c f l p s}}} {
   set files [glob -nocomplain -types $types -dir $dir -- *]
   foreach x [glob -nocomplain -types {d} -dir $dir -- *] {
	   set files [concat $files [[lindex [info level 0] 0] [file join $dir $x]]]
	  }
   return [lsort $files];
 };
