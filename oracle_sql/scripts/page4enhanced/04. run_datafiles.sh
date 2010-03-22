. ./commons
PAGE="page4enhanced"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

function datafiles(){
  echo "Datafiles"
  echo
  echo "File$SEP\Tablespace$SEP\Size$SEP\Status"
  run_sql "$HERE/04. sql_datafiles.sql"
  cat "$ORACLE_OUTPUT_FILE"
}

if [ $OTHER == "YES" ]; then
  params > $REDIR\_1enhdatafiles
fi 
