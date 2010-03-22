. ./commons
PAGE="page6"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

DATE="`date +"%d %b %Y"`"

function format_output(){
  line_number=`cat $ORACLE_OUTPUT_FILE | wc -l`
  if [[ $line_number -gt 0 ]];then
    for (( i=1;i<=$line_number;i++ ));do
      segm="`sed -n $i\p $TMP_FILE`"
      if [[ -n "$1" ]];then
	segm="$1 $SEP$segm$SEP $SEP";
      fi
      dbs="`sed -n $i\p $ORACLE_OUTPUT_FILE`"
      if [[ -z "$segm" ]];then
	segm="$SEP$SEP$SEP";
      fi
      echo $segm $SEP $SEP $dbs
    done
  else
    if [[ -n "$1" ]];then
      segm="$1 $SEP NA$SEP $SEP";
    fi
  fi
  echo $segm $SEP $SEP $dbs
}

function activecalls(){
  echo "ACTIVECALLS"
  echo
  echo "MTS$SEP CALLSTARTED$SEP STATUS$SEP COUNT(*)$SEP $SEP SEGMENT_NAME$SEP BYTES$SEP MB"
  if [[ -n $ORACLE_V8 ]];then
    run_sql $HERE/"06. sql_activecalls_v8.sql"
    gawk -F$SEP 'BEGIN{OFS="'$SEP'"}{print "",$1,"",$2}' $ORACLE_OUTPUT_FILE > $TMP_FILE
  else
    run_sql $HERE/"06. sql_activecalls.sql"
    cat $ORACLE_OUTPUT_FILE > $TMP_FILE
  fi
  run_sql $HERE/"06. sql_activecallsdba.sql"
  OUT=$(format_output)
  echo "$OUT"
  nr_xls=10; padding=$(expr $nr_xls - $(echo "$OUT" | wc -l))
  padding $padding
  sum=`gawk -F$SEP 'BEGIN{OFS="'$SEP'";sum1=0;sum2=0}{sum1+=$2;sum2+=$3}END{ print sum1/1024,sum2}' $ORACLE_OUTPUT_FILE`
  echo "$SEP $SEP $SEP $SEP $SEP Total Space occupied by Table$SEP $sum"
  echo
}

function rtsstatus(){
  echo "RTSSTATUSQUEUE"
  echo "DATE$SEP RECORDS$SEP $SEP $SEP $SEP SEGMENT_NAME$SEP BYTES$SEP MB"
  if [[ -n $ORACLE_V8 ]];then
    echo "$DATE$SEP NA$SEP $SEP $SEP $SEP NA$SEP NA$SEP NA"
    echo
    echo "$SEP $SEP $SEP $SEP $SEP Total Space occupied by Table$SEP 0$SEP 0"
  else
    run_sql $HERE/"06. sql_rtsstatusqueue.sql"
    cat $ORACLE_OUTPUT_FILE > $TMP_FILE
    run_sql $HERE/"06. sql_rtsstatusqueuedba.sql"
    OUT=$(format_output "$DATE")
    echo "$OUT"
    nr_xls=2; padding=$(expr $nr_xls - $(echo "$OUT" | wc -l))
    padding $padding
    sum=`gawk -F$SEP 'BEGIN{OFS="'$SEP'";sum1=0;sum2=0}{sum1+=$2;sum2+=$3}END{ print sum1/1024,sum2}' $ORACLE_OUTPUT_FILE`
    echo "$SEP $SEP $SEP $SEP $SEP Total Space occupied by Table$SEP $sum"
  fi
  echo
}

function status(){
  echo "STATUSQUEUE"
  echo "DATE$SEP RECORDS$SEP $SEP $SEP $SEP SEGMENT_NAME$SEP BYTES$SEP MB"
  if [[ -n $ORACLE_V8 ]];then
    echo "$DATE$SEP NA$SEP $SEP $SEP $SEP NA$SEP NA$SEP NA"
    echo
    echo "$SEP $SEP $SEP $SEP $SEP Total Space occupied by Table$SEP 0$SEP 0"
  else
    run_sql $HERE/"06. sql_statusqueue.sql"
    cat $ORACLE_OUTPUT_FILE > $TMP_FILE
    run_sql $HERE/"06. sql_statusqueuedba.sql"
    OUT=$(format_output "$DATE")
    echo "$OUT"
    nr_xls=2; padding=$(expr $nr_xls - $(echo "$OUT" | wc -l))
    padding $padding
    sum=`gawk -F$SEP 'BEGIN{OFS="'$SEP'";sum1=0;sum2=0}{sum1+=$2;sum2+=$3}END{ print sum1/1024,sum2}' $ORACLE_OUTPUT_FILE`
    echo "$SEP $SEP $SEP $SEP $SEP Total Space occupied by Table$SEP $sum"
  fi
  echo
}

function voipcdr(){
  echo "VOIPCDRQUEUE"
  echo "DATE$SEP RECORDS$SEP $SEP $SEP $SEP SEGMENT_NAME$SEP BYTES$SEP MB"
  if [[ -n $ORACLE_V8 ]];then
    echo "$DATE$SEP NA$SEP $SEP $SEP $SEP NA$SEP NA$SEP NA"
    echo
    echo "$SEP $SEP $SEP $SEP $SEP Total Space occupied by Table$SEP 0$SEP 0"
  else
    run_sql $HERE/"06. sql_voipcdrqueue.sql"
    cat $ORACLE_OUTPUT_FILE > $TMP_FILE
    run_sql $HERE/"06. sql_voipcdrqueuedba.sql"
    OUT=$(format_output "$DATE")
    echo "$OUT"
    nr_xls=2; padding=$(expr $nr_xls - $(echo "$OUT" | wc -l))
    padding $padding
    sum=`gawk -F$SEP 'BEGIN{OFS="'$SEP'";sum1=0;sum2=0}{sum1+=$2;sum2+=$3}END{ print sum1/1024,sum2}' $ORACLE_OUTPUT_FILE`
    echo "$SEP $SEP $SEP $SEP $SEP Total Space occupied by Table$SEP $sum"
  fi
  echo
}

function invalidobj(){
  echo "Invalid objects"
  echo "OOWN$SEP ONAME$SEP OTYPE$SEP PROB"
  run_sql $HERE/"06. sql_invalidobjects.sql"
  if [ ! -s "$ORACLE_OUTPUT_FILE" ];then
    echo "none" > "$ORACLE_OUTPUT_FILE"
  fi
  cat "$ORACLE_OUTPUT_FILE"
  nr_xls=6; padding=$(expr $nr_xls - $(cat "$ORACLE_OUTPUT_FILE" | wc -l))
  padding $padding
  echo
}

function brokenjobs(){
  echo "Broken jobs"
  run_sql $HERE/"06. sql_brokenjobs.sql"
  if [ ! -s "$ORACLE_OUTPUT_FILE" ];then
    echo "none" > "$ORACLE_OUTPUT_FILE"
  fi
  cat "$ORACLE_OUTPUT_FILE"
  nr_xls=6; padding=$(expr $nr_xls - $(cat "$ORACLE_OUTPUT_FILE" | wc -l))
  padding $padding
  echo
}

function readlines(){
  while read line
    do
    time=${line%%;*}
    #check for the last 3 days : 259200
    if [ -n "$time" ];then
      if [ "$time" -gt 259200 ];then
	echo ${line#*;} $SEP >> $TMP_FILE
      fi
    fi
  done < "$ORACLE_OUTPUT_FILE"
}

function statistics(){
  rm $TMP_FILE
  echo "Statistics"
  
  run_sql $HERE/"06. sql_statistics_dba_jobs.sql"
  if [ -s "$ORACLE_OUTPUT_FILE" ];then

    echo "USER INDEXES$SEP $SEP " > $TMP_SQL
    echo "TABLE_NAME$SEP LAST_ANALYZED$SEP " >> $TMP_SQL
    run_sql $HERE/"06. sql_statistics_user_indexes.sql"
    
    readlines
    cat $TMP_FILE | sort -k 2 -t $SEP | uniq >> $TMP_SQL

    echo "USER TAB PARTITIONS$SEP $SEP " > $TMP_FILE
    echo "TABLE_NAME$SEP LAST_ANALYZED$SEP " >> $TMP_FILE
    run_sql $HERE/"06. sql_statistics_user_tab_partitions.sql"
    
    readlines
    if [ -s $TMP_FILE ];then
      l1=`cat $TMP_SQL | wc -l`;l2=`cat $TMP_FILE | wc -l`
      if [ $l1 -gt $l2 ];then max=$l1;else max=$l2;fi
      rm $ORACLE_OUTPUT_FILE;
      for (( i=1;i<=$max;i++ ));do
	l1="`sed -n $i\p $TMP_SQL`"
	l2="`sed -n $i\p $TMP_FILE`"
	if [ -z "$l1" ];then l1="$SEP $SEP";fi
	if [ -z "$l2" ];then l2="$SEP $SEP";fi
	echo $l1 $SEP $l2  >> $ORACLE_OUTPUT_FILE
      done
    fi
    cat $ORACLE_OUTPUT_FILE > $TMP_SQL

    echo "USER TABLES$SEP $SEP " > $TMP_FILE
    echo "TABLE_NAME$SEP LAST_ANALYZED$SEP " >> $TMP_FILE
    run_sql $HERE/"06. sql_statistics_user_tables.sql"
    
    readlines
    if [ -s $TMP_FILE ];then
      l1=`cat $TMP_SQL | wc -l`;l2=`cat $TMP_FILE | wc -l`
      if [ $l1 -gt $l2 ];then max=$l1;else max=$l2;fi
      rm $ORACLE_OUTPUT_FILE;
      for (( i=1;i<=$max;i++ ));do
	l1="`sed -n $i\p $TMP_SQL`"
	l2="`sed -n $i\p $TMP_FILE`"
	if [ -z "$l1" ];then l1="$SEP $SEP";fi
	if [ -z "$l2" ];then l2="$SEP $SEP";fi
	echo $l1 $SEP $l2  >> $ORACLE_OUTPUT_FILE
      done
    fi

    if [ `cat $ORACLE_OUTPUT_FILE | wc -l` -gt 2 ];then
      cat $ORACLE_OUTPUT_FILE
    fi
    rm $ORACLE_OUTPUT_FILE
  else
    echo "No jobs for statistics";
  fi
}

if [ $OTHER == "YES" ]; then
  activecalls > $REDIR\_1activecalls
  rtsstatus > $REDIR\_2rtsstatus
  status > $REDIR\_3status
  voipcdr > $REDIR\_4voipcdr
  invalidobj > $REDIR\_5invalidobj
  brokenjobs > $REDIR\_6brokenjobs
  statistics > $REDIR\_7statistics
fi
