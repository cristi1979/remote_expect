. ./commons
PAGE="page7"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

function files(){
  run_sql "$HERE/07. sql_mind_logs.sql"
  dos2unix "$ORACLE_OUTPUT_FILE" 2> /dev/null

  if [[ -n $ORACLE_V8 ]];then
    ab_file="${ORACLE_SID}ALRT.LOG"
    echo "D:\orant\NET80\LOG" >> "$ORACLE_OUTPUT_FILE"
  else
    ab_file="alert_${ORACLE_SID}.log"
    echo "$ORACLE_HOME/network/log" >> "$ORACLE_OUTPUT_FILE"
  fi
  mce="MindCorrExceptions.log"
  moe="MindOracleExceptions.log"
  lst_file="listener.log"

  if [[ $OS_VER == "CYGWIN_NT" ]];then
    ab_file="$(find $(cygpath $(cat "$ORACLE_OUTPUT_FILE" | uniq)) -name $ab_file)"
    lst_file="$(find $(cygpath $(cat "$ORACLE_OUTPUT_FILE" | uniq)) -name $lst_file)"
    mce="$(find $(cygpath $(cat "$ORACLE_OUTPUT_FILE" | uniq)) -name $mce)"
    moe="$(find $(cygpath $(cat "$ORACLE_OUTPUT_FILE" | uniq)) -name $moe)"
  else
    ab_file="$(find $(cat "$ORACLE_OUTPUT_FILE" | uniq) -name $ab_file)"
    lst_file="$(find $(cat "$ORACLE_OUTPUT_FILE" | uniq) -name $lst_file)"
    mce="$(find $(cat "$ORACLE_OUTPUT_FILE" | uniq) -name $mce)"
    moe="$(find $(cat "$ORACLE_OUTPUT_FILE" | uniq) -name $moe)"
  fi
}

function alertbill(){
  echo "Alert_BILL"
  echo
  if [[ -n $ab_file ]];then
    #select to_char(sysdate,'Dy Mon DD HH24:MM:SS YYYY') from dual
    date_begin=$(date --date="1 month ago" +%b)
    date_year=$(date --date="1 month ago" +%Y)
    ROW=$(grep --regexp="^[a-z|A-Z]\{3\} $date_begin [0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} $date_year" "$ab_file" -m 1 -n)
    ROW=${ROW%%:*}
    LAST_ROW=$(cat "$ab_file" | wc -l)
    sed -n "$ROW,$LAST_ROW p" "$ab_file" | grep -i -E "ora-\|Errors in file" -B2 -A1
  else
    echo "File Alert_BILL does not exist."
  fi
  echo
  echo
  echo
}

function mindcorex(){
  echo "Mind correlation"
  echo
  if [[ -n $mce ]]; then
    FS="----------------------------------------------------------------------------------------------------\n"
    gawk 'BEGIN{RS="";FS="'$FS'"} {
      for (i=1;i<=NF;i++){
	split($i,all,"\n");
	split(all[1],time,":");
	split(time[2]":"time[3]":"time[4],date," ")
	#day/month/year
	split(date[1],date_spec,"/")
	split(date[2],time_spec,":")
	#year,month,day,hour,min,sec
	sec=mktime(date_spec[3]" "date_spec[2]" "date_spec[1]" "time_spec[1]" "time_spec[2]" "time_spec[3]);
	now=systime()
	if (( now-sec < 30*24*3600 ) &&
	  (all[11]!="SQL error message : ORA-0000: normal, successful completion") )
	  print date[1],date[2],all[11]
      }
      }' $mce
  else
    echo "File MindCorrExceptions.log does not exist."
  fi
  echo
  echo
  echo
}

function mindorex(){
  echo "Mind Oracle exceptions"
  echo
  if [[ -n $moe ]]; then
  FS="----------------------------------------------------------------------------------------------------\n"
  gawk 'BEGIN{RS="";FS="'$FS'"} {
    for (i=1;i<=NF;i++){
      split($i,all,"\n");
      split(all[1],time,":");
      split(time[2]":"time[3]":"time[4],date," ")
      #day/month/year
      split(date[1],date_spec,"/")
      split(date[2],time_spec,":")
      #year,month,day,hour,min,sec
      sec=mktime(date_spec[3]" "date_spec[2]" "date_spec[1]" "time_spec[1]" "time_spec[2]" "time_spec[3]);
      now=systime()
      if (( now-sec < 30*24*3600 ) &&
	(all[11]!="SQL error message : ORA-0000: normal, successful completion") )
	print date[1],date[2],all[11]
    }
    }' $moe
  else
    echo "File MindOracleExceptions.log does not exist."
  fi
  echo
  echo
  echo
}

function listenererr(){
  echo "Listener errors"
  echo
  if [[ $OS_VER == "CYGWIN_NT" ]];then
    echo "Check errors in $(cygpath -w $lst_file). What are TNS- errors?";
  else
    echo "Check errors in $lst_file. What are TNS- errors?";
  fi
}

if [ $MODE == "DATABASE" ]; then
  files
  alertbill > $REDIR\_1alertbill
  mindcorex > $REDIR\_2mindcorex
  mindorex > $REDIR\_3mindorex
  listenererr > $REDIR\_4listenererr
fi
