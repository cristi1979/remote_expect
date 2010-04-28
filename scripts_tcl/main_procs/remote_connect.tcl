proc remote_connect {} {
  if {[info exists ::disabled]} {puts "\n\tDisabled flag is set. Exit now."; return $::ERR_DISABLED}
  set ::files_to_get [list]
  lappend ::files_to_get { "somethingthatdoesnotexist" }
  set ret [ssh_connect]
  if {$ret} {puts "\n\tERR: Can't connect.";return $ret}
  set ret [ssh_prompt]
  if {$ret} {puts "\n\tERR: Can't get new prompt.";return $ret}
  ssh_launch_cmd "mkdir -p $::bkp_rem_dir"
  if {[test_dir $::bkp_rem_dir]} {return $::ERR_GENERIC}
  ssh_launch_cmd "df -k $::bkp_rem_dir | awk '{if (NF>3)print \$(NF-2)}' | tail -1"
  if { "$::saved_output"  < $::bkp_rem_dir_freespace } {
    puts "\n\tERR: Remote temporary directory does not have enough free space: only $::saved_output and we need $::bkp_rem_dir_freespace.";
   return $::ERR_GENERIC;
  }

  set improved_path {PATH=$PATH:/sbin:/usr/sbin:/usr/cluster/bin:/usr/bin:/usr/xpg4/bin/:/usr/sfw/bin/:/usr/local/bin/:/tmp/mindcti/$(uname -a | cut -d " " -f 3,6 | sed s/\ //)/bin/:/usr/ucb:/etc/:/usr/platform/sun4u/sbin/:/usr/platform/$(uname -i)/sbin/}
  return [expr [ssh_launch_cmd "cd $::bkp_rem_dir"] && [ssh_launch_cmd "export $improved_path"] && [getOS] && [getProc] &&[getVer] && [getHostname] && [ssh_copy_gnutools]]
}
