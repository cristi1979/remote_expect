. ./commons
PAGE="page2enhanced"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

function params(){
  echo "Database parameters"
  echo
  echo "Name$SEP\Value$SEP\Description"
  run_sql "$HERE/02. sql_params.sql"
  cat "$ORACLE_OUTPUT_FILE"  
}

if [ $OTHER == "YES" ]; then 
  params > $REDIR\_1enhparameters
fi
