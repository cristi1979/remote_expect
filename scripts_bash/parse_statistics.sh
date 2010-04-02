#!/bin/sh

# we expect the files in $BASE_PATH_TO_REMOTE_FILES are updated regullary
# we don't permit concomitent runs of the script
#  - this is done via the $PID_FILE, where we keep our current pid
# 
# for each directory in $BASE_PATH_TO_REMOTE_FILES (which is $CUSTOMER),
#   we go over all files (where we get $IP)
#     and if they match our expression ($WORD) AND we have defined $BASE_RRD_PATH && $CUSTOMER && $IP
# 	  check if PATH_WHERE_TO_EXTRACT exists and if so, clean it
# 	  extract the current file to PATH_WHERE_TO_EXTRACT
# 	  for each file in PATH_WHERE_TO_EXTRACT (which has the statistic type)
# 	    check if the statistic type was parsed (via an array)
# 		  if not, add the statistic type to the array, so we can skip it next time
# 		  parse all files of type statistic type
# 		  if the parser didn't finished successfully, copy the files to bkp for later inspection
# 	  clean PATH_WHERE_TO_EXTRACT

#from here we presume that we have:
# DIR - customer name
# FILE - [type_ip_extra]
#	type - apps_exceptions | apps_logs | apps_statistics | hw_stats
#	ip - remote machine ip
#	extra - usually something like log file name_lod dir name (we don't care)

##send email
#echo Message | mailx -s _Subject_ -a /path/to/file/to/attach -a /am/other/file/to/attach cineva.cumva@mindcti.com

echo "args are $@"


exit 0
ME="$0"
MY_PID=$$
PID_FILE="/var/run/mind/extract_files"
BASE_RRD_PATH="/media/share/rrdfiles"
BASE_PATH_TO_REMOTE_FILES="/media/share/backups/remote_files"
WORD="_unix_statistics"
RET=0
mkdir -p $BASE_RRD_PATH

echo "starting at $(date)"
OLD_PID="$(ps `cat $PID_FILE 2> /dev/null` | grep -v 'PID TTY      STAT   TIME COMMAND')"
### I have my pid file AND OLD_ME is not dead
if [ -e $PID_FILE -a -n "$OLD_PID" ];then
    echo "me, already running" >&2
else
  echo "me, not running"
  echo $MY_PID > $PID_FILE
  for customer_dir in $(find $BASE_PATH_TO_REMOTE_FILES -maxdepth 1 ! -path "$BASE_PATH_TO_REMOTE_FILES" -type d -print | sort); do
    #from something like /media/share/backups/remote_files/afripa (customer_dir) to afripa: last string after slash
    CUSTOMER=${customer_dir##*/}
    echo "  * starting for customer $CUSTOMER"
    for filepath in $(find $customer_dir -maxdepth 1 -type f -print | sort);do
      #all files from media/share/backups/remote_files/afripa/ (customer_dir)
      path=${filepath%/*}
      filename=${filepath##*/}
      base=${filename%.*}
      ext=${filename##*.}
      if expr match "$base" .*"$WORD".* > /dev/null;then
	IP=${base%"$WORD"*}
	if [[ $BASE_RRD_PATH && $CUSTOMER && $IP ]]; then
	  echo "  * starting for file $filepath"
	  PATH_WHERE_TO_EXTRACT=$BASE_RRD_PATH/tmp/$CUSTOMER/$IP
	  if [[ -d $PATH_WHERE_TO_EXTRACT ]]; then 
	    echo "  * cleaning $PATH_WHERE_TO_EXTRACT"
	    rm -rf $PATH_WHERE_TO_EXTRACT;
	  fi
	  mkdir -p $PATH_WHERE_TO_EXTRACT
	  echo "  * extracting files in $PATH_WHERE_TO_EXTRACT"
	  tar -xvzf $filepath -C $PATH_WHERE_TO_EXTRACT > /dev/null
	  echo "  * start parsing files"
	  arraystats=()
	  for statsfile in $(find $PATH_WHERE_TO_EXTRACT -type f -print | sort);do
	    RRD_PATH=$BASE_RRD_PATH/rrd/$CUSTOMER/$IP
	    statsfilename=${statsfile##*/}
	    statsbase=${statsfilename%.*}
	    RRD_NAME=$(echo $statsbase | cut -d'_' -f2- | cut -d'_' -f1)
	    already_parse=0
	    for i in ${arraystats[@]}; do
	      if [[ $i == ${RRD_NAME} ]] ; then
		already_parse=1
		break
	      fi;
	    done
	    if [[ $already_parse == 0 ]];then
	      arraystats=( "${arraystats[@]}" "$RRD_NAME" )
	      all_statistics_files=$(find $PATH_WHERE_TO_EXTRACT -iregex ".*/.*_$RRD_NAME\_.*" -type f -print | sort)
	      echo parser --rrdpath $RRD_PATH --customer $CUSTOMER --ip $IP --rrdfilename $RRD_NAME $all_statistics_files
	      if [[ $? == 0 ]];then
		echo "  * parsing files $RRD_NAME finished successfully"
	      else
		echo "  * error when trying to parse files $RRD_NAME. Backing up the files for later inspection."
		RET=1
		BKP_PATH=$BASE_RRD_PATH/bkp/$(date +%s)$(mktemp -u -p /)
		BKP_NAME=$CUSTOMER\_$IP\_${statsfile##*/}
		for i in ${all_statistics_files[@]}; do
		  echo "  * "cp $i $BKP_PATH/$BKP_NAME;
		done
	      fi
	    fi
	  done
	  echo "  * cleaning $PATH_WHERE_TO_EXTRACT"
	  rm -rf $PATH_WHERE_TO_EXTRACT
	else
	  echo "  * Not all needed variables are defined. Bail out."
	  echo "  * base path is $BASE_RRD_PATH, customer is $CUSTOMER, ip is $IP.";
	  RET=1
	fi
	echo "------------------"
      fi
    done
    echo "++++++++++++++++++"
  done
fi

echo "finish at $(date)"
exit $RET
