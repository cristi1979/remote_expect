proc ssh_copy_gnutools {} {
  set spawn_id $::sshid 
  set ret $::OK
  set check_prg "$::bkp_rem_dir/gnu_files/ls"

  if {$::copy_tools=="yes"} {
    if {$::operatingsystem==$::ossolaris} {
      ssh_launch_cmd "($check_prg --help &>/dev/null && exit 0;exit 1)"
      if {![ssh_get_lasterror]} {
	puts "\n\tMSG: Gnu tools found."
	set ret $::OK
      } else {
	puts "\n\tMSG: Copy our own gnu programs."
	set prgname $::operatingsystemver$::operatingsystemproc.tgz
	if {[scp_put_files "$::scripts_tcl_dir/../solaris_progs/$prgname"]} {
	  puts "\n\tERR: Could not copy gnu tools."
	  set ret $::ERR_GENERIC
	} else {
	  ssh_launch_cmd "gunzip -dc $::bkp_rem_dir/$prgname | tar -xvf -"
	  ssh_launch_cmd "chmod +x $::bkp_rem_dir/gnu_files/*"
	  ssh_launch_cmd "ln -s $::bkp_rem_dir/gnu_files/libpcre.so.0.0.1 $::bkp_rem_dir/gnu_files/libpcre.so.0"
	  ssh_launch_cmd "ln -s $::bkp_rem_dir/gnu_files/libintl.so.8.0.2 $::bkp_rem_dir/gnu_files/libintl.so.8"
	  ssh_launch_cmd "ln -s $::bkp_rem_dir/gnu_files/libiconv.so.2.5.0 $::bkp_rem_dir/gnu_files/libiconv.so.2"
	  ssh_launch_cmd "LD_LIBRARY_PATH=$::bkp_rem_dir/gnu_files/"
	  ssh_launch_cmd "($check_prg --help &>/dev/null && exit 0;exit 1)"
	  if {[ssh_get_lasterror]} {
	    puts "\n\tERR: Gnu tools copied, but can't execute them."
	    set ret $::ERR_GENERIC
	  } else {
	    set ret $::OK
	  }
	}
      }
    } else {
      puts "\n\tERR: We will copy the gnu tools only for $::ossolaris. We have here $::operatingsystem."
    }
  } else {
    set ret $::ERR_GENERIC
  }
  return $ret
}