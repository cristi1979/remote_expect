#1=timpul	---
#x+1=Filesystem
#x+2=kbytes
#x+3=used
#x+4=avail
#x+5=capacity	---
#x+6=Mounted on
gawk 'BEGIN{RS="";FS="\n"}{$2=$2;if (NR>1)print $0"	"}' mind_dfstat_1.log | \
  sed s/"Filesystem            kbytes    used   avail capacity  Mounted on"//
