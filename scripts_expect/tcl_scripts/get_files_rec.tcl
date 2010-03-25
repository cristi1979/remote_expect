proc get_files_rec {{dir .} {types {b c f l p s}} {filespec "*"}} {
  set files [glob -nocomplain -types $types -dir $dir -- $filespec]
  foreach x [glob -nocomplain -types {d} -dir $dir -- *] {
   set files [concat $files [get_files_rec [file join $dir $x] $types $filespec]]
  }
  set filelist {}
  foreach x $files {
   while {[string range $x 0 1]=="./"} {
    regsub ./ $x "" x
   }
   lappend filelist $x
  }
  return $filelist;
 };
