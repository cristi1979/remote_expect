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