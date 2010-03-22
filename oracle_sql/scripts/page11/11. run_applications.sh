. ./commons
PAGE="page11"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

function vers(){
  echo -n "Installed version"$SEP
  run_sql "$HERE/11. sql_vers.sql"
  cat "$ORACLE_OUTPUT_FILE" 
}

function knownissues(){
  echo
  echo "Known issues"
  echo
}

function changes(){
  echo -n "Last SP upgrade"
  echo $SEP"Date of last SP upgrade"
  echo -n "Last SP installed"
  echo $SEP"What was the last installed SP"
  echo -n "Hardware changes"
  echo $SEP"Details regarding HW changes"
  echo -n "Network changes"
  echo $SEP"Details regarding network changes - modified IPs etc"
}

if [ $OTHER == "YES" ]; then
  version > $REDIR\_1version
  knownissues > $REDIR\_2knownissues
  changes > $REDIR\_3changes
fi

