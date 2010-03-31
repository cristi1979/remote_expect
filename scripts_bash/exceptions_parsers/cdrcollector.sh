function cdrcollector() {
  reg='ERROR Description :'

  cat $(ls -tr ${FILES[@]}) | gawk --re-interval -v RS="$regdate $regtime $reg(\r\n|\n)" -v FS="\n" '{
    if (NR>1) {
      if ( $2 != "java.io.IOException: Can'"'"'t obtain connection to host" ) {
	print MATCH
	print $1 ;
	print $2;
	print "++++++++++++++++++++++++";
      }
    }
    MATCH=RT
  }' 
} 
