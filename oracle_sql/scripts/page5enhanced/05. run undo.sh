. ./commons
PAGE="page5enhanced"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

function undo(){
  echo "Undo"
  echo
  echo -n "Type of undo management"
  run_sql "$HERE/05. sql_type.sql"
  cat "$ORACLE_OUTPUT_FILE"
  run_sql "$HERE/05. sql_rollback.sql"
  cat "$ORACLE_OUTPUT_FILE"
  run_sql "$HERE/05. sql_undotbs.sql"
  cat "$ORACLE_OUTPUT_FILE"
  run_sql "$HERE/05. sql_undoretention.sql"
  cat "$ORACLE_OUTPUT_FILE"
}

if [ $OTHER == "YES" ]; then
  undo > $REDIR\_1enhundo
fi
