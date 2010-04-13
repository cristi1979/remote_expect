. ./commons
PAGE="page3"
HERE="$SCRIPTS_DIR/$PAGE"
REDIR="$OUT/$PAGE"

if [[ -n $ORACLE_V8 ]];then
  TNSPING=tnsping80
else
  TNSPING=tnsping
fi
PING_WIN="$WINDIR"/system32

function pingme(){
  echo PING

  IP=$($TNSPING $CONN | grep "Attempting to contact" | sed s/\=/\=\ /g | sed -r 's/^.* ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).*$/\1/' |grep -E '.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

  OUT1=$($PING_WIN/ping.exe $IP)
  OUT2=$(ping $IP -c 3)
  echo "$OUT1" | sed '/^$/d'
  echo
  echo "$OUT2" | sed '/^$/d'
  nr_xls=20; padding=$(expr $nr_xls - $(echo "$OUT1" | wc -l) - $(echo "$OUT2" | wc -l))
  padding $padding
  echo
}

function tns_ping(){
  echo TNSPING
  $TNSPING $CONN
}

function netconfig(){
  if [[ $OS_VER == "CYGWIN_NT" ]];then
    ipconfig /all
  else
    ifconfig -a
  fi
}

if [ $MODE == "BILLING" ]; then
  pingme > $REDIR\_1pingme
  tns_ping > $REDIR\_2tnsping
  netconfig > $REDIR\_3netconfig
fi
