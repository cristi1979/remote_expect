function udrserver() {
  reg='--------------------------------------------------------------------------------------------------'

  cat $(ls -tr ${FILES[@]}) | gawk --re-interval -v RS="$reg\n" -v FS="\n" '{
    if (NR>1) {
      split($0,array, "\n")
      max=0
      for (i=0;i<length(array);i++) {
	if (array[i]!="") {
	  newarray[max]=array[i]
	  max++
	}
      }
      pos=2
      if ( (newarray[pos] != "com.mind.udrdistribution.export.utils.exceptions.FTPExUnreachableTarget: Connection timed out") &&
	  (newarray[pos] != "ipworks.IPWorksException: java.net.BindException: Cannot assign requested address") &&
	  (newarray[pos] != "com.mind.udrdistribution.export.utils.exceptions.FTPExUnreachableTarget: Connection refused")) {
	print newarray[0]
	print newarray[1]
	print newarray[2]
	print newarray[3]
	print newarray[length(newarray)-1]
	print "++++++++++++++++++++++++\n";
      }
    }
  }'
} 
