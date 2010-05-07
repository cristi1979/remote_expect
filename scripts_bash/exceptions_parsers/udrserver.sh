function udrserver() {
  reg='--------------------------------------------------------------------------------------------------'

  for filename in ${FILES[@]}; do
  cat $filename | gawk --re-interval -v RS="$reg\n" -v FS="\n" '{
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
	  (newarray[pos] != "com.mind.udrdistribution.export.utils.exceptions.FTPExUnreachableTarget: Connection refused") &&
	  (newarray[pos] != "java.lang.IllegalStateException: Cannot receive records in this state.") &&
	  (newarray[pos] !~ "^com.mind.udrdistribution.export.utils.exceptions.FTPExWrongUserOrPassword: PASS \\[ [[:print:]]{1,} \\] : 530 User \\[ [[:print:]]{1,} \\] cannot log in.$") &&
	  (newarray[pos] != "EXCEPTION LOG1") ) {
	print newarray[length(newarray)-1]
	#print newarray[0]
	print newarray[1]
	print newarray[2]
	print newarray[3]
	print "++++++++++++++++++++++++\n";
      }
    }
  }'
  done
} 
