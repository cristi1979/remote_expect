function cdrcollector() {
  reg='ERROR Description :'

  cat $(ls -tr ${FILES[@]}) | gawk --re-interval -v RS="$regdate $regtime $reg\n" -v FS="\n" '{
    if (NR>1) {
      if ( ($2 != "java.io.IOException: Can'"'"'t obtain connection to host") &&
	  ($2 != "com.mind.utils.ftp.client.engine.FtpException: Data: CloseSocket, Transfer Aborted") ) {
	print MATCH
	print $1;
	print $2;
	print $3;
	print "++++++++++++++++++++++++\n";
      }
    }
    MATCH=RT
  }' 
} 
