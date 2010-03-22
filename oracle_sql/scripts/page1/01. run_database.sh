. ./commons
PAGE="page1"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

function machine_data(){
  echo "Machine data"
  if [[ $OS_VER == "SunOS" ]];then
    FS="====================================\n"
    /usr/platform/sun4u/sbin/prtdiag | \
    gawk 'BEGIN{RS="";FS="'$FS'"}
      {print $2}' | sort | uniq | \
      grep -v "               E$          CPU                  CPU     Temperature" | \
      grep -v "CPU  Freq      Size        Implementation       Mask    Die   Amb.  Status      Location" | \
      grep "MHz" | \
      gawk 'BEGIN{OFS="'$SEP'"}
	{print "CPU",$5" "$2"MHz";}
	END{print "Cores/CPU",NR}' | uniq
    /usr/platform/sun4u/sbin/prtdiag | grep "^Memory size" | gawk -F\: 'BEGIN { OFS = "'$SEP'" } {print "RAM",$2}'
  else
    #try to use /proc in windows also
    if [[ $OS_VER == "CYGWIN_NT" ]];then
      Psinfo.exe -c -t $SEP > "$TMP_FILE";
      #systeminfo.exe
      #gawk -F$SEP 'BEGIN { OFS = "'$SEP'" } ;{
      #  print "CPU",$16;
      #  print "Cores/CPU",$14;
      #  print "RAM",$17;}' "$TMP_FILE";
    fi
    cat /proc/cpuinfo | sort | uniq | grep "model name" | gawk -F\: 'BEGIN { OFS = "'$SEP'" } {print "CPU",$2}'
     cat /proc/cpuinfo | sort | uniq | grep "cpu count" | gawk -F\: 'BEGIN { OFS = "'$SEP'";printf "" } {cpus=$2}END{if (!NR) cpus=1;print "Cores/CPU",cpus}'
    cat /proc/meminfo | grep "MemTotal" | gawk -F\: 'BEGIN { OFS = "'$SEP'" } {print "RAM",$2}'
  fi

  echo "Architecture"
  echo "Type"
  echo

  echo "Operating system"
  if [[ $OS_VER == "CYGWIN_NT" ]];then
    echo "Type$SEP\Windows"
    gawk -F$SEP 'BEGIN { OFS = "'$SEP'" } ;{
      split ($3,os,",")
      print "Version", os[1] " SP"$6
      }' "$TMP_FILE"
  else
    echo "Type$SEP$OS_VER"
    echo -n "Version"$SEP
    uname -a | gawk 'BEGIN { OFS = "'$SEP'" }
    {for (i=3;i<=NF;i++)printf $i,""}'
  fi
  rm "$TMP_FILE"
  echo
}

function database(){
  echo "Database"
  run_sql "$HERE/01. sql_database_info.sql"
  cat "$ORACLE_OUTPUT_FILE"
  echo
}

function stats(){
  echo -n "Automatic statistics collection"
  run_sql "$HERE/01. sql_stats.sql"
  if [[ -s "$ORACLE_OUTPUT_FILE" ]];then
    echo "$SEP Yes"
  else
    echo "$SEP No"
  fi
}

function options(){
  echo "Options"
  run_sql "$HERE/01_sql_options.sql"
  cat "$ORACLE_OUTPUT_FILE"
  echo
}

function spfile(){
  echo "Spfile implementation"
  run_sql "$HERE/01_sql_spfile.sql"
  cat "$ORACLE_OUTPUT_FILE"
  echo
}

function performance_mon(){
  echo "Performance monitoring"
  echo
  #Supported Platforms
  #Linux HP-UX AIX Tru64 Solaris
  echo -n "OSWatcher installed"$SEP
  if [[ $OS_VER == "UNIX" ]];then
    OSW=$(ps -elf | grep startOSW.sh | grep -v grep)
    if [[ -n $OSW ]];then
      echo "YES";
    else
      echo "NO";
    fi
  else
    echo "NO";
  fi
  
  echo -n "LTOM installed"$SEP
  run_sql "$HERE/01. sql_ltom.sql"
  if [[ -n $(cat "$ORACLE_OUTPUT_FILE") ]];then
    echo "NO";
  else
    echo "YES";
  fi
  
  echo -n "PERFSTAT/AWR installed"$SEP
  run_sql "$HERE/01. sql_perfstat.sql"
  if [[ -n $(cat "$ORACLE_OUTPUT_FILE") ]];then
    echo "NO";
  else
    echo "YES";
  fi
}

function schemas(){
  echo "Mind schemas"
  cat "$HERE/01. sql_schemas.sql" | sed s/\%\&enter_username\%/$DB_USER/ > $TMP_FILE
  run_sql "$TMP_FILE"
  cat "$ORACLE_OUTPUT_FILE"
}

if [ $MODE == "DATABASE" ]; then
  machine_data > $REDIR\_1machine_data
fi

if [ $OTHER == "YES" ]; then
  database > $REDIR\_1database
  options > $REDIR\_2options
  spfile > $REDIR\_3spfile
  performance_mon > $REDIR\_4performance_mon
  schemas > $REDIR\_5schemas
  stats > $REDIR\_6stats
fi
