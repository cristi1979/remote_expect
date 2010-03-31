#each line has the applications running, so we can get the exact time for them 
export TZ=CST+6CDT
gawk 'BEGIN{time=1259222420;RS="PID USERNAME  SIZE   RSS STATE  PRI NICE      TIME  CPU PROCESS/NLWP"}{print $0; time+=30;print "\n\n" strftime("%c %z",time);}' mind_prstat_4.log