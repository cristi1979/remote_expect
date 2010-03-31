gawk 'BEGIN{RS="";FS="\n";coco=0;}{
  $2=$2;
  if (!index($0,"%usr")){
    if (!index($0,"Average")){
      if (coco==1 && NF>4){
      	headerx = header1;
      	for (i=0;i<NF-4;i++)
	  headerx = headerx header;
	headerx = headerx header2;
	print headerx;
        coco = 0;
      }
      print 
    }
  }else {
    coco = 1;
    header1="time	    %usr    %sys    %wio   %idle	  scall/s sread/s swrit/s  fork/s  exec/s rchar/s wchar/s";
    header2="	  pgout/s ppgout/s pgfree/s pgscan/s %ufs_ipf	       swpin/s bswin/s swpot/s bswot/s pswch/s";
    header="           device        %busy   avque   r+w/s  blks/s  avwait  avserv ";
  }
  }' sarstat_2.log > ./teste
