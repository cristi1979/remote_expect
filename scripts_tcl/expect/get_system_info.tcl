proc getOS {} {
  set ret [ssh_launch_cmd "uname"]
  switch $::saved_output {
    "SunOS" {
      set ::operatingsystem $::ossolaris
    }
    "Linux" {
      set ::operatingsystem $::oslinux
    }
    default {
      set ::operatingsystem ""
    }
  }
  return $ret 
}

proc getProc {} {
  set ret [ssh_launch_cmd "uname -p"]
  switch $::saved_output {
    "sparc" {
      set ::operatingsystemproc $::saved_output
    }
    "i386" {
      set ::operatingsystemproc "x86"
    }
    "i686" {
      set ::operatingsystemproc "x86"
    }
    default {
      set ::operatingsystemproc ""
    }
  }
  return $ret 
} 

proc getVer {} {
  set ret [ssh_launch_cmd "uname -r"]
  set ::operatingsystemver $::saved_output
  return $ret 
}
