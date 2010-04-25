#!/bin/sh
. ./commons
PAGE="page2"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

function disk(){
  echo "Disk"
  echo
  echo "Filesystem;mountpoint;free;total"

if [[ $OS_VER == "CYGWIN_NT" ]];then
    Psinfo.exe -d "coco" -c -t $SEP > "$TMP_FILE"
    OUT="$(gawk -F$SEP 'BEGIN{OFS="'$SEP'"}{
      for (i=3;i<=NF;i++){
	if ($(i+1) == "Fixed"){
	  MOUNT=$i
	  i=i+2
	  FS=$i
	  i=i+2
	  SIZE=$i
	  i++
	  FREE=$i
	  print FS,MOUNT,FREE,SIZE
	  i++
	}
      }
    }' "$TMP_FILE")"
  elif [[ $OS_VER == "SunOS" ]];then
    OUT="$(df -hl | gawk 'BEGIN{OFS="'$SEP'"}{print $1,$6,$4,$2}' | grep -v "Filesystem$SEP\Mounted$SEP\avail$SEP\size" | grep "^/dev")"
  else
    OUT="$(df -hPl | gawk 'BEGIN{OFS="'$SEP'"}{print $1,$6,$4,$2}' | grep -v "Filesystem$SEP\Mounted$SEP\avail$SEP\size" | grep "^/dev")"
  fi

  echo "$OUT"
  nr_xls=8; padding=$(expr $nr_xls - $(echo "$OUT" | wc -l))
  padding $padding
  echo
}

function tablespacedata(){
  echo "Tablespace data"
  echo
  if [[ -n $ORACLE_V8 ]];then
    echo "TABLESPACE_NAME$SEP File Count$SEP Size(MB)$SEP Free(MB)$SEP Used(MB)$SEP Max Ext(MB)$SEP % Free$SEP Graph"
    run_sql $HERE/"02. sql_tablespace_data_v8.sql";
  else
    echo "NAME$SEP MBYTES$SEP USED$SEP FREE$SEP PCT_USED$SEP LARGEST$SEP MAX_SIZE$SEP PCT_MAX_USED"
    run_sql $HERE/"02. sql_tablespace_data.sql";
  fi
  cat "$ORACLE_OUTPUT_FILE" | sed s/^*[a-z]\ // | sed s/^\ [a-z]\ //
  nr_xls=12; padding=$(expr $nr_xls - $(cat "$ORACLE_OUTPUT_FILE" | wc -l))
  padding $padding
  echo
}

function partitions(){
  echo "Partitions"
  echo "Table Name$SEP First Partition$SEP Last Partition$SEP Tablespace Name$SEP Current value"
  if [[ -n $ORACLE_V8 ]];then
    run_sql $HERE/"02. sql_partitions1_v8.sql"
    cat "$ORACLE_OUTPUT_FILE" > "$TMP_FILE"
    run_sql $HERE/"02. sql_partitions2_v8.sql"
    gawk -F$SEP '{print $(NF-1)"'$SEP'"}' "$ORACLE_OUTPUT_FILE" > "$TMP_SQL"
    run_sql "$TMP_SQL"
    line_number=$(cat "$TMP_FILE" | wc -l)
    line_number=$(echo $line_number)
    for (( i=1;i<=$line_number;i++ ));do
      value="`sed -n $i\p "$ORACLE_OUTPUT_FILE"`"
      key="`sed -n $i\p "$TMP_SQL" | gawk '{print $NF}' | sed s/\)\;$//`"
      #first=`grep ^$key "$TMP_FILE" | sed ':a;N;$!ba;s/\n//g' `
      dos2unix "$TMP_FILE" 2> /dev/null
      first=$(grep ^$key "$TMP_FILE")
      echo $first $SEP $value
    done
  else
    set -x
    run_sql $HERE/"02. sql_partitions.sql"
    cat "$ORACLE_OUTPUT_FILE" > "$TMP_FILE"
    gawk -F$SEP '{print $(NF-1)"'$SEP'"}' "$ORACLE_OUTPUT_FILE" > "$TMP_SQL"
    run_sql "$TMP_SQL"
    line_number=$(cat "$TMP_FILE" | wc -l)
    line_number=$(echo $line_number)
    for (( i=1;i<=$line_number;i++ ));do
      first="$(sed -n $i\p "$TMP_FILE" | gawk -F$SEP '{for (i=1;i<NF-1;i++)printf $i"'$SEP'"}' | sed s/\;$//)"
      value="$(sed -n $i\p "$ORACLE_OUTPUT_FILE")"
      echo $first$SEP $value
    done
    exit
  fi
  nr_xls=20; padding=$(expr $nr_xls - $line_number)
  padding $padding
  echo
}

function log_sizes(){
  echo "Log sizes"
  echo
  echo "Name$SEP Size (MB)$SEP Need archival"
  run_sql $HERE/"02. sql_logs.sql"
  dos2unix "$ORACLE_OUTPUT_FILE" 2> /dev/null
  ab_dir="$(cat "$ORACLE_OUTPUT_FILE" )"
  #ab_dir="`cat "$ORACLE_OUTPUT_FILE" | sed ':a;N;$!ba;s/\n//g' `"
  if [[ -n $ORACLE_V8 ]];then
    ab_file="$ab_dir"/${ORACLE_SID}ALRT.LOG
    lst_file="D:\orant\NET80\LOG"/listener.log
  else
    ab_file="$ab_dir"/alert_${ORACLE_SID}.log
    lst_file="$ORACLE_HOME/network/log"/listener.log
  fi
  AB_SIZE=`ls -la "$ab_file" | gawk '{print $5/1024/1024}'`
  LST_SIZE=`ls -la "$lst_file" | gawk '{print $5/1024/1024}'`
  echo -n "alert_BILL.log"$SEP $AB_SIZE
  if [ "$MATEI" ];then
    if [[  ${AB_SIZE/.*} -gt 100 ]];then
      echo $SEP\Yes
    else
      echo $SEP\No
    fi
  else
    echo
  fi
  echo -n Listener.log$SEP $LST_SIZE
  if [ "$MATEI" ];then
    if [[  ${LST_SIZE/.*} -gt 100 ]];then
      echo $SEP\Yes
    else
      echo $SEP\No
    fi
  else
    echo
  fi
}

if [ $MODE == "DATABASE" ]; then
  disk > $REDIR\_1disk
fi

if [ $OTHER == "YES" ]; then
  tablespacedata > $REDIR\_2tablespacedata
  partitions > $REDIR\_3partitions
fi

if [ $MODE == "DATABASE" ]; then
  log_sizes > $REDIR\_4log_sizes
fi
