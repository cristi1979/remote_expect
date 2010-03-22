. ./commons
PAGE="page5"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

function control_files(){
  echo "Control files"
  echo
  echo "STATUS$SEP NAME"
  run_sql $HERE/"05. sql_controlfiles.sql"
  cat $ORACLE_OUTPUT_FILE
  nr_xls=6; padding=$(expr $nr_xls - $(cat "$ORACLE_OUTPUT_FILE" | wc -l))
  padding $padding
  echo
}

function db_growth(){
  echo "Database growth since last audit"
  echo
  echo "Tablespace name$SEP Used MB during last audit$SEP Used MB during current audit"
  if [[ -n $ORACLE_V8 ]];then
    run_sql $HERE/../page2/"02. sql_tablespace_data_v8.sql";
  else
    run_sql $HERE/../page2/"02. sql_tablespace_data.sql";
  fi
  gawk -F$SEP 'BEGIN{OFS="'$SEP'"}{print $1,"here from last audit",$5}' "$ORACLE_OUTPUT_FILE" | sed s/^*[a-z]\ // | sed s/^\ [a-z]\ //
  nr_xls=12; padding=$(expr $nr_xls - $(cat "$ORACLE_OUTPUT_FILE" | wc -l))
  padding $padding
  echo
}

function backup(){
  echo "Backup"
  echo
  echo "Type$SEP Status"
  if [[ -n $ORACLE_V8 ]];then
    echo "N/A"
  else
    echo "check for a scheduled job that runs rman or a cron job for this"
  fi
}

if [ $OTHER == "YES" ]; then
  control_files > $REDIR\_1control_files
  db_growth > $REDIR\_2db_growth
  backup > $REDIR\_3backup
fi
