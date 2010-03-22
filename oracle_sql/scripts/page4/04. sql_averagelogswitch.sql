select avg(first_time - (select first_time
                           from v$log_history x
                          where x.RECID = y.recid - 1
                            and x.thread# = y.thread#)) * 24 * 60 * 60 "Average swich rate (seconds)",
       min(first_time - (select first_time
                           from v$log_history x
                          where x.RECID = y.recid - 1
                            and x.thread# = y.thread#)) * 24 * 60 * 60 "Minimum switch time (seconds)"
  from v$log_history y
 where trunc(first_time) >= trunc(sysdate) - 30;
