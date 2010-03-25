proc directpathname {filename} {
     set savewd [pwd]
     set realFile [file join $savewd $filename]
     # Hmm.  This (unusually) looks like a job for do...while!
     cd [file dirname $realFile]
     set dir [pwd] ;# Always gives a canonical directory name
     set filename [file tail $realFile]
     while {![catch {file readlink $filename} realFile]} {
         cd [file dirname $realFile]
         set dir [pwd]
         set filename [file tail $realFile]
     }
     cd $savewd
     return [file join $dir $filename]
 }
