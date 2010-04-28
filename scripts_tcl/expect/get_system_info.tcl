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
  puts "\n\tMSG: Set OS to $::operatingsystem."
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
  puts "\n\tMSG: Set proc ver to $::operatingsystemproc."
  return $ret 
} 

proc getVer {} {
  set ret [ssh_launch_cmd "uname -r" "&1" "/dev/null"]
  set ::operatingsystemver $::saved_output
  puts "\n\tMSG: Set OS ver to $::operatingsystemver."
  return $ret 
}

proc getHostname {} {
  set ret [ssh_launch_cmd "hostname" "&1" "/dev/null"]
  set ::operatingsystemhostname $::saved_output
  puts "\n\tMSG: Set hostname to $::operatingsystemhostname."
  return $ret 
}
