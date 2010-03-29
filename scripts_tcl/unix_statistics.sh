#!/bin/bash

#we need bash, a proper ps
##kill $(ps -eax | /usr/xpg4/bin/grep -E -e vmstat -e iostat -e netstat -e unix_statistics.sh -e ping -e sar -e sadc -e mpstat -e prstat | awk '{print $1}')
##kill $(ps -ef | /usr/xpg4/bin/grep -E -e vmstat -e iostat -e netstat -e unix_statistics.sh -e ping -e sar -e sadc -e mpstat -e prstat | awk '{print $2}')

MIND_JAVA_PROGS="
-Dprogram=asc
-Dprogram=collector
-Dprogram=processor
-Dprogram=RTS
-Dprogram=SystemAttendant
"

export PATH=$PATH:/sbin:/usr/sbin:/usr/cluster/bin:/usr/bin:/usr/xpg4/bin/:/usr/sfw/bin/:/usr/local/bin/:/tmp/mindcti/bin/:/usr/ucb:/etc/:/usr/platform/sun4u/sbin/:/usr/platform/`uname -i`/sbin/
OS=$(uname)

function timegtmt_sol ()
{ /usr/bin/truss /usr/bin/date 2>&1 |  nawk -F= '/^time\(\)/ {gsub(/ /,"",$2);print $2'; }
function timegtm_linux ()
{ date +%s; }
function timegmt_perl ()
{ perl -e 'print int(time)."\n"'; }
function timegmt () 
{
  if $(which perl) < /dev/null > /dev/null 2>&1; then 
    timegmt_perl;
  elif [ $OS == "Linux" ]; then 
    timegtm_linux;
  elif [ $OS == "SunOS" ]; then
    timegtmt_sol;
  else
    echo "can't make time";
  fi
}

if [ $OS == "Linux" ]; then 
  MY_EGREP="grep";
elif [ $OS == "SunOS" ]; then
  MY_EGREP="/usr/xpg4/bin/grep";
else
  echo "can't make egrep";
fi

CRT_FILENR=$(date "+%u")
INTERVAL=30
COUNT=5760
NAME=$(uname -a | cut -f 2 -d " ")
PID_FILE=$STATS_OUT_DIR/PIDS_$CRT_FILENR

if [ ! "$STATS_OUT_DIR" ]; then
  echo "STATS_OUT_DIR is not defined. Wrong..."
  exit 1;
fi

OLD_CMDS_NAMES=$(awk '{print $2}' $PID_FILE)
if [ "$OLD_CMDS_NAMES" ]; then
  PIDS=$(ps -e -o user,pid,ppid,comm,args | \
	$MY_EGREP $(awk '{print $1}' $PID_FILE | xargs -L 1 echo " -e") | \
	while read user pid ppid comm args ; do 
	  if [[ $user == $USER ]] ; then 
		(for i in ${OLD_CMDS_NAMES[@]};do 
		  [ "$i" == "$comm" -o "$args" == "bash /tmp/mindcti/unix_statistics.sh" ] && exit 0; 
		done; exit 1) && echo -n "-e $pid ";
	  fi;
    done)
  PPIDS=$(ps -e -o user,pid,ppid,args |  $MY_EGREP -e $(echo $PIDS) |\
    while read user pid ppid comm args ; do 
	  if [[ $user == $USER ]] ; then 
	    (for i in ${PIDS[@]};do 
		  [ "$i" == "$ppid" ] && exit 0; 
		done; exit 1) && echo -n "-e $pid ";
	  fi;
	done)
  echo "Found pids $PIDS and ppids $PPIDS"
  kill $(ps -e -o user,pid,ppid,args |  grep sadc | $MY_EGREP -e $(echo $PIDS) -e $(echo $PPIDS) | \
   awk '{print $2}')
  #kill $(echo $PIDS $PPIDS | sed s/-e//g)
fi

echo > $PID_FILE

function machine_info() {
  echo "========================================"
  echo "timezone"
  #perl -e 'use Time::Local; @t = localtime(time); $dif=(timegm(@t)-timelocal(@t))/3600;print $dif."\n";'
  echo $(date +%H)-$(date -u +%H) | bc
  echo "========================================"
  echo "uname"
  uname -a
  echo "========================================"
  echo "iostat disks map"
  paste -d= <(iostat -x | awk '{print $1}') <(iostat -xn | awk '{print $NF}') | tail +3
  echo "========================================"
  echo "/etc/vfstab"
  cat /etc/vfstab
  echo "========================================"
  echo "iostat"
  iostat -En
  echo "========================================"
  echo "metastat"
  metastat
  echo "========================================"
  echo "metastat short"
  metastat -p
  echo "========================================"
  echo "metaset"
  metaset
  echo "========================================"
  echo "metastat per set"
  metaset | grep "Set name =" | awk '{print $4}' | sed s/,//g | \
	while read set; do 
		/sbin/metastat -s $set;
	done
  echo "========================================"
  echo "didadm"
  didadm -l
  echo "========================================"
  echo "scstat"
  scstat
  echo "========================================"
  echo "cfgadm"
  /etc/cfgadm -al
  echo "========================================"
  echo "prtdiag"
  prtdiag -v
  echo "========================================"
  echo "psrinfo"
  psrinfo -v
  psrinfo -vp
  echo "========================================"
  echo "ifconfig"
  ifconfig -a
}

function mind_java_stat() {
  ALL=$(for i in ${MIND_JAVA_PROGS[@]};do echo "-e $i";done)
  for ((i=0;i<$COUNT;i++));do
    #perl -e 'print int(time)."\n"'
    timegmt
    ps -e -o pid,pcpu,vsz,args | grep java | $MY_EGREP -i $ALL
    sleep $INTERVAL
  done
}

function nrprocsstat() {
  for ((i=0;i<$COUNT;i++));do
    #perl -e 'print int(time)."\n"'
    timegmt
    ps -e | wc -l
    sleep $INTERVAL
  done
}

function my_stat() {
  for ((i=0;i<$COUNT;i++));do
    perl -e 'print int(time)."\n"'
    $1
    sleep $INTERVAL
  done
}

function dfstat() {
  my_stat "df -k"
}
function tempstat() {
  my_stat "prtpicl -v -c temperature-sensor"
}
function voltagestat() {
  my_stat "prtpicl -v -c voltage-sensor"
}
function fanstat() {
  my_stat "prtpicl -v -c fan"
}

function pingstat() {
  my_stat "ping $DB_IP $(TO=$INTERVAL;let TO=$TO/2;echo $TO)"
}

function tomcatstat {
  XML_FILE="$STATS_OUT_DIR/mindtomcat.xml"
  for ((i=0;i<$COUNT;i++));do
    echo > $XML_FILE
    wget http://localhost:8080/manager/status?XML=true --http-user=admin --http-passwd=admin -O $XML_FILE;
    if [ "$(tail -1 $XML_FILE)" ];then
    #if [ -s $XML_FILE ]; then
      #perl -e 'print int(time)."\n"';
      timegmt
      xml -p $XML_FILE | egrep "ELEMENT memory|ELEMENT threadInfo|ELEMENT requestInfo|^    \|---ELEMENT|^    \+---ELEMENT";
      sleep $INTERVAL;
    else
      echo "We need xml executable from oracle client and to have tomcat installed here. No good."
      exit 1
    fi
  done
}

function allnetstat() {
  ifconfig -a | grep flags | grep -v LOOPBACK | cut -d " " -f 1 | sed s/://g | while read IF; do 
	PREP=$IF\_$CRT_FILENR
    FILE_NAME="$STATS_OUT_DIR/$NAME-mind_netstat_$PREP.log"
    echo "" > $FILE_NAME
    rm -f $FILE_NAME
    #perl -e 'print int(time)."\n"' > $FILE_NAME
    timegmt
    netstat -i -I $IF $INTERVAL $COUNT >> $FILE_NAME &
    echo $! $1 >> $PID_FILE
  done
}

function stat_cmd() {
  COMMAND=${1%% *}
  FILE_NAME="$STATS_OUT_DIR/$NAME-mind_${COMMAND##*/}_$CRT_FILENR.log"
  echo "" > $FILE_NAME
  rm -f $FILE_NAME
  #perl -e 'print int(time)."\n"' > $FILE_NAME
  timegmt
  $1 >> $FILE_NAME &
  echo $! $1 >> $PID_FILE
}

if [ $OS == "Linux" ]; then 
  echo "cucu"
elif [ $OS == "SunOS" ]; then
  stat_cmd "iostat -xnsrc -Tu $INTERVAL $COUNT"
  stat_cmd "mpstat $INTERVAL $COUNT"
  stat_cmd "prstat -s cpu -cn10 $INTERVAL $COUNT"
  stat_cmd "sar -A $INTERVAL $COUNT"
  stat_cmd "vmstat $INTERVAL $COUNT"
  stat_cmd "allnetstat"
  stat_cmd "dfstat"
  stat_cmd "nrprocsstat"
  stat_cmd "tempstat"
  stat_cmd "fanstat"
  stat_cmd "tomcatstat"
  stat_cmd "voltagestat"
  stat_cmd "pingstat"
  stat_cmd "ping -n -I $INTERVAL $DB_IP 56 $COUNT"
  #nfsstat, kstat
  stat_cmd "machine_info"
  stat_cmd "mind_java_stat"
else
  echo "can't make stats";
fi
#/usr/sfw/bin/ipmitool sdr list |grep temp
exit
#Display processes with the highest CPU utilization
#ps -eo pid,pcpu,args | sort +1n
