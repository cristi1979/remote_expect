. ./commons
PAGE="page4"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

function log_files(){
  echo Log files
  echo
  echo "GROUP#$SEP STATUS$SEP TYPE$SEP MEMBER"
  run_sql $HERE/"04. sql_logfiles.sql"

  if [[ -n $ORACLE_V8 ]];then
    OUT=$(gawk -F$SEP 'BEGIN{OFS="'$SEP'"}{print $1,$2,"",$3}' $ORACLE_OUTPUT_FILE)
  else
    OUT=$(gawk -F$SEP 'BEGIN{OFS="'$SEP'"}{print $1,$2,$3,$4}' $ORACLE_OUTPUT_FILE)
  fi
  echo "$OUT"
  nr_xls=8; padding=$(expr $nr_xls - $(echo "$OUT" | wc -l))
  padding $padding
  echo
}

function average_log_switch(){
  echo "Average log switch rate for the last month"
  echo
  echo "Average swich rate (seconds)$SEP Minimum switch time (seconds)"
  if [[ -n $ORACLE_V8 ]];then
    run_sql $HERE/"04. sql_averagelogswitch_v8.sql"
    min=`sed -n 1p $ORACLE_OUTPUT_FILE`
    avg=`sed -n 2p $ORACLE_OUTPUT_FILE`
    echo $min$SEP $avg
  else
    run_sql $HERE/"04. sql_averagelogswitch.sql"
    out=`cat $ORACLE_OUTPUT_FILE | sed s/\)\;$//`
    echo $out
  fi
  echo
}

function archive_log_status(){
  echo "Archive log status"
  rm $ORACLE_OUTPUT_FILE
  if [[ -n $ORACLE_V8 ]];then
    run_sql $HERE/"04. sql_archivelogstatus_v8.sql"
    cat $ORACLE_OUTPUT_FILE
    nr_xls=8; padding=$(expr $nr_xls - $(cat "$ORACLE_OUTPUT_FILE" | wc -l))
  else
    if [ $MODE == "BILLING" ]; then
      echo "log as sysdba on the server and execute \" `cat $HERE/"04. sql_archivelogstatus.sql"` \""
      nr_xls=8; padding=$(expr $nr_xls - 1)
    fi
    if [ $MODE == "DATABASE" ]; then
      run_sql_sysdba $HERE/"04. sql_archivelogstatus.sql"
      cat $ORACLE_OUTPUT_FILE
      nr_xls=8; padding=$(expr $nr_xls - $(cat "$ORACLE_OUTPUT_FILE" | wc -l))
      padding $padding
    fi
  fi
  padding $padding
  echo
}

function log_sizes(){
  run_sql $HERE/"04. sql_logsizes.sql"
  echo "Log buffer size"$SEP `sed -n 1p $ORACLE_OUTPUT_FILE`
  echo
  echo "Log member size"$SEP `sed -n 2p $ORACLE_OUTPUT_FILE`
}

function log_switchstats(){
  run_sql "$HERE/04. sql_logswitchstats.sql"
  echo "Log switch statistics"
  echo
 cat "$ORACLE_OUTPUT_FILE"
}

if [ $OTHER == "YES" ]; then
  log_files > $REDIR\_1log_files
  average_log_switch > $REDIR\_2average_log_switch
  archive_log_status > $REDIR\_3archive_log_status
  log_sizes > $REDIR\_4log_sizes
  log_switchstats > $REDIR\_5log_switchstats
fi
