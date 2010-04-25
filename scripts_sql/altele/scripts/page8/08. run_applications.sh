. ./commons
PAGE="page8"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

function applications(){
  echo "Applications"
  echo
  echo "MACHINECODE$SEP MODULENAME$SEP MODULEVERSION$SEP LASTUPDATE$SEP STORAGE FREE"
  run_sql $HERE/"08. sql_modules.sql"
  cat "$ORACLE_OUTPUT_FILE"
}

function knownissues(){
  echo
  echo "Known issues"
  echo
}

if [ $OTHER == "YES" ]; then
  applications > $REDIR\_1applications
  knownissues > $REDIR\_2knownissues
fi
